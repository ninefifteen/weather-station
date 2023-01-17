//
//  WeatherStationMapViewModel.swift
//  WeatherStation
//
//  Created by Shawn Seals on 1/14/23.
//

import Factory
import Foundation
import MapKit

@MainActor
class WeatherStationMapViewModel: ObservableObject {
    
    // MARK: - API
    
    @Published var isLoading = false
    
    @Published var selectedDay: Day = .today {
        didSet {
            updateDisplayedStations()
        }
    }
    
    @Published var stations: [Station] = []
    
    private(set) lazy var initialRegion: MKCoordinateRegion = {
        let center = CLLocationCoordinate2D(latitude: 40.9240, longitude: -108.0955)
        let span = MKCoordinateSpan(latitudeDelta: 25.0, longitudeDelta: 20.0)
        return MKCoordinateRegion(center: center, span: span)
    }()
    
    let dayPickerTodayText = "Today"
    let dayPickerTomorrowText = "Tomorrow"
    
    func onAppear() async {
        await fetchWeather()
    }
    
    // MARK: - Properties
    
    @Injected(Container.weatherService) private var weatherService: WeatherService
    
    private var weatherToday: [Station] = []
    private var weatherTomorrow: [Station] = []

    // MARK: - Functions
    
    private func fetchWeather() async {
        do {
            isLoading = true
            async let today = weatherService.weather(for: .today)
            async let tomorrow = weatherService.weather(for: .tomorrow)
//            try await Task.sleep(nanoseconds: UInt64(2 * Double(NSEC_PER_SEC)))
            weatherToday = try await today
            weatherTomorrow = try await tomorrow
            isLoading = false
            updateDisplayedStations()
        } catch {
            // TODO: handle error
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
