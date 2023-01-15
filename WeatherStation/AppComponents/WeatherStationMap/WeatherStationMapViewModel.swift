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
    
    @Published var displayedStations: [Station] = []
    
    private(set) lazy var initialRegion: MKCoordinateRegion = {
        let center = CLLocationCoordinate2D(latitude: 40.9240, longitude: -108.0955)
        let span = MKCoordinateSpan(latitudeDelta: 25.0, longitudeDelta: 20.0)
        return MKCoordinateRegion(center: center, span: span)
    }()
    
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
            async let today = weatherService.weather(for: .today)
            async let tomorrow = weatherService.weather(for: .tomorrow)
            weatherToday = try await today
            weatherTomorrow = try await tomorrow
            updateDisplayedStations()
        } catch {
            // TODO: handle error
        }
    }
    
    private func updateDisplayedStations() {
        displayedStations = weatherToday
    }
}
