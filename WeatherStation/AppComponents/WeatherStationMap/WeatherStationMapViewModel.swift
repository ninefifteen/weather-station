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
class WeatherStationMapViewModel: ObservableObject {
    
    // MARK: - API
    
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
    
    // MARK: - Properties
    
    @Injected(Container.weatherService) private var weatherService: WeatherService
    
    private var appError: AppError? {
        didSet {
            if appError != nil { isAlertShown = true }
        }
    }
    
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
}
