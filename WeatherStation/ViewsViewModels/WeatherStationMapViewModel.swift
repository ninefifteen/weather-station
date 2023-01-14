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
    
    @Published var stations: [Station] = []
    
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
        } catch {
            // TODO: handle error
        }
    }
}
