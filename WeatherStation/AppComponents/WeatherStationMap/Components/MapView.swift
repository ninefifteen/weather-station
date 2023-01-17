//
//  MapView.swift
//  WeatherStation
//
//  Created by Shawn Seals on 1/14/23.
//

import MapKit
import SwiftUI

struct MapView: UIViewRepresentable {
    
    // MARK: - API
    
    init(initialRegion: MKCoordinateRegion, stations: [Station], selectedStationField: StationField) {
        _displayRegion = State(initialValue: initialRegion)
        self.stations = stations
        self.selectedStationField = selectedStationField
    }
    
    // MARK: - Properties
    
    @State private var displayRegion: MKCoordinateRegion
    
    private let stations: [Station]
    private let selectedStationField: StationField
        
    // MARK: - UIViewRepresentable
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.setRegion(displayRegion, animated: false)
        mapView.mapType = .standard
        mapView.isRotateEnabled = false
        mapView.delegate = context.coordinator
        updateAnnotations(for: mapView)
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        context.coordinator.isUpdating = true
        if context.coordinator.selectedStationField != selectedStationField {
            context.coordinator.selectedStationField = selectedStationField
            updateAnnotations(for: mapView, isFieldSwitch: true)
        } else {
            updateAnnotations(for: mapView, isFieldSwitch: false)
        }
        reselectSelectedAnnotationId(mapView, context: context)
        context.coordinator.isUpdating = false
    }
    
    // MARK: = Functions
    
    func reselectSelectedAnnotationId(_ mapView: MKMapView, context: Context) {
        guard let selectedStationId = context.coordinator.selectedStationId,
              let selectedAnnotation = mapView.annotations.first(where: { annotation in
                  if let stationAnnotation = annotation as? StationAnnotation {
                      return stationAnnotation.station.id == selectedStationId
                  }
                  return false
              }) else { return }
        mapView.selectAnnotation(selectedAnnotation, animated: false)
    }
    
    private func updateAnnotations(for mapView: MKMapView, isFieldSwitch: Bool = false) {
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
    
    // MARK: - Coordinator
    
    func makeCoordinator() -> MapCoordinator {
        .init(displayRegion: $displayRegion)
    }
    
    final class MapCoordinator: NSObject, MKMapViewDelegate {
        
        init(displayRegion: Binding<MKCoordinateRegion>) {
            _displayRegion = displayRegion
        }
        
        private let stationAnnotationIdentifier = "station"
        
        @Binding private var displayRegion: MKCoordinateRegion
        
        var isUpdating = false
        var selectedStationField: StationField = .temperature
        var selectedStationId: String?
        
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
            if let _ = annotation as? StationAnnotation, !isUpdating {
                selectedStationId = nil
            }
        }
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            displayRegion = mapView.region
        }
    }
    
    // MARK: - MKAnnotation Station Wrapper
    
    final private class StationAnnotation: NSObject, MKAnnotation {
        
        init(station: Station) {
            self.station = station
        }
        
        let station: Station
        
        var coordinate: CLLocationCoordinate2D {
            CLLocationCoordinate2D(latitude: station.latitude, longitude: station.longitude)
        }
    }
}
