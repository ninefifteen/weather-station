//
//  WeatherStationMapViewModel.swift
//  WeatherStation
//
//  Created by Shawn Seals on 1/14/23.
//

import Factory
import Foundation
import MapKit

enum StationField {
    case temperature
    case wind
    case precipitation
}

@MainActor
class WeatherStationMapViewModel: NSObject, ObservableObject {
    
    // MARK: - API
    
    @Published var displayRegion: MKCoordinateRegion?
    
    @Published var isAlertShown = false {
        didSet {
            if !isAlertShown { appError = nil }
        }
    }
    
    @Published var isLoading = false
    
    @Published var selectedDay: Day = .today {
        didSet {
            updateDisplayedStations()
        }
    }
    
    @Published var selectedStationField: StationField = .temperature
    @Published var stations: [Station] = []
        
    var alertMessage: String {
        appError?.alertMessage ?? AppError.unknown.alertMessage
    }
    
    var alertTitle: String {
        appError?.alertTitle ?? AppError.unknown.alertTitle
    }
    
    private(set) lazy var initialRegion: MKCoordinateRegion = {
        let center = CLLocationCoordinate2D(latitude: 40.9240, longitude: -108.0955)
        let span = MKCoordinateSpan(latitudeDelta: 25.0, longitudeDelta: 20.0)
        return MKCoordinateRegion(center: center, span: span)
    }()
    
    let dayPickerTodayText = "Today"
    let dayPickerTomorrowText = "Tomorrow"
    
    let fieldPickerTemperatureText = "Temp"
    let fieldPickerWindText = "Wind"
    let fieldPickerPrecipitationText = "Precip %"
    
    func onAppear() async {
        await fetchWeather()
    }
    
    func updateMapView(_ mapView: MKMapView) {
        isUpdating = true
        if previousSelectedStationField != selectedStationField {
            previousSelectedStationField = selectedStationField
            updateAnnotations(for: mapView, isFieldSwitch: true)
        } else {
            updateAnnotations(for: mapView, isFieldSwitch: false)
        }
        reselectSelectedAnnotationId(mapView)
        isUpdating = false
    }
    
    override init() {}
    
    // MARK: - Constants
    
    private let stationAnnotationIdentifier = "station"
    
    // MARK: - Properties
    
    @Injected(Container.weatherService) private var weatherService: WeatherService
    
    private var appError: AppError? {
        didSet {
            if appError != nil { isAlertShown = true }
        }
    }
    
    private var isUpdating = false
    private var previousSelectedStationField: StationField = .temperature
    private var selectedStationId: String?
    
    private var weatherToday: [Station] = []
    private var weatherTomorrow: [Station] = []

    // MARK: - Functions
    
    private func fetchWeather() async {
        do {
            isLoading = true
            async let today = weatherService.weather(for: .today)
            async let tomorrow = weatherService.weather(for: .tomorrow)
            weatherToday = try await today
            weatherTomorrow = try await tomorrow
            updateDisplayedStations()
        } catch {
            showAlert(for: error)
        }
        isLoading = false
    }
    
    private func showAlert(for error: Error) {
        if let error = error as? AppError {
            appError = error
        } else {
            appError = AppError.unknown
        }
    }
    
    private func updateDisplayedStations() {
        switch selectedDay {
        case .today:
            stations = weatherToday
        case .tomorrow:
            stations = weatherTomorrow
        }
    }
    
    // MARK: - Map Functions
    
    func reselectSelectedAnnotationId(_ mapView: MKMapView) {
        guard let selectedStationId = selectedStationId,
              let selectedAnnotation = mapView.annotations.first(where: { annotation in
                  if let stationAnnotation = annotation as? StationAnnotation {
                      return stationAnnotation.station.id == selectedStationId
                  }
                  return false
              }) else { return }
        mapView.selectAnnotation(selectedAnnotation, animated: false)
    }
    
    func updateAnnotations(for mapView: MKMapView, isFieldSwitch: Bool = false) {
        let rect = mapView.visibleMapRect
        
        let stationsInRegion = Set(stations.filter { $0.coordinate.isContained(in: rect) })
        let currentlyDisplayedAnnotations = Set(mapView.annotations.compactMap { $0 as? StationAnnotation })
        let currentlyDisplayedStations = Set(currentlyDisplayedAnnotations.map { $0.station })
        let currentlyDisplayedStationsInRegion = currentlyDisplayedStations.filter{ $0.coordinate.isContained(in: rect) }
        
        var annotationsToAdd: [StationAnnotation] = []
        var annotationsToRemove: [StationAnnotation] = []
        
        if isFieldSwitch {
            // Remove and re-add all annotations to redraw label text.
            annotationsToAdd = stationsInRegion.map { StationAnnotation(station: $0) }
            annotationsToRemove = Array(currentlyDisplayedAnnotations)
        } else {
            // Get the annotations to add by finding the stations that are in the visible region and are not already being displayed.
            annotationsToAdd = stationsInRegion.subtracting(currentlyDisplayedStationsInRegion).map { StationAnnotation(station: $0) }
            // Get the stations to remove by finding the currently displayed stations that are not in the set of stations in the region.
            annotationsToRemove = Array(currentlyDisplayedAnnotations.filter { !stationsInRegion.contains($0.station) })
        }
        
        mapView.addAnnotations(annotationsToAdd)
        mapView.removeAnnotations(annotationsToRemove)
    }
}

extension WeatherStationMapViewModel: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let stationAnnotation = annotation as? StationAnnotation else { return nil }
        return annotationView(for: stationAnnotation, in: mapView)
    }
    
    private func annotationView(
        for stationAnnotation: StationAnnotation,
        in mapView: MKMapView
    ) -> MKAnnotationView {
        let annotationView: StationAnnotationView

        if let view = mapView.dequeueReusableAnnotationView(
            withIdentifier: stationAnnotationIdentifier
        ) as? StationAnnotationView {
            annotationView = view
        } else {
            annotationView = StationAnnotationView(
                annotation: stationAnnotation,
                reuseIdentifier: stationAnnotationIdentifier
            )
        }
        
        annotationView.displayPriority = .defaultHigh
        annotationView.canShowCallout = true
        
        configureStationAnnotationView(annotationView, with: selectedStationField, in: stationAnnotation)
        
        let calloutView = StationCalloutView(station: stationAnnotation.station)
        annotationView.detailCalloutAccessoryView = calloutView

        return annotationView
    }
    
    private func configureStationAnnotationView(
        _ view: StationAnnotationView,
        with selectedStationField: StationField,
        in stationAnnotation: StationAnnotation
    ) {
        var text: String?
        view.displayWindIndicator(false)
        
        switch selectedStationField {
        case .temperature:
            if let value = stationAnnotation.station.temperature {
                text = String(format: "%.0f", value) + "°"
            }
        case .wind:
            if let value = stationAnnotation.station.windSpeed {
                text = String(format: "%.0f", value) + "kts"
            }
            if let value = stationAnnotation.station.windDirection {
                view.displayWindIndicator(true, windDirection: value)
            }
        case .precipitation:
            if let value = stationAnnotation.station.chanceOfPrecipitation {
                text = String(format: "%.0f", value) + "%"
            }
        }
        if let text = text {
            view.label.text = text
            view.label.alpha = 1
        } else {
            view.label.text = "000"
            view.label.alpha = 0
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        if let stationAnnotation = annotation as? StationAnnotation {
            selectedStationId = stationAnnotation.station.id
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect annotation: MKAnnotation) {
        if let stationAnnotation = annotation as? StationAnnotation, !isUpdating, stationAnnotation.station.id == selectedStationId {
            selectedStationId = nil
        }
    }
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        Task { @MainActor in
            displayRegion = mapView.region
        }
    }
}
