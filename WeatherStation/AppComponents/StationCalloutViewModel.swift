//
//  StationCalloutViewModel.swift
//  WeatherStation
//
//  Created by Shawn Seals on 1/14/23.
//

import Foundation

class StationCalloutViewModel {
    
    // MARK: - API
    
    let precipitaionKeyLabelText = "Precipitation"
    let temperatureKeyLabelText = "Temperature"
    let windDirectionKeyLabelText = "Wind Direction"
    let windSpeedKeyLabelText = "Wind Speed"
    
    var stationIdValueLabelText: String { station.id }
    var stationNameValueLabelText: String { station.name }
    
    var precipitationValueLabelText: String {
        guard let value = station.chanceOfPrecipitation else { return "Not Available" }
        return String(format: "%.0f", value) + "%"
    }
    
    var temperatureValueLabelText: String {
        guard let value = station.temperature else { return "Not Available" }
        return String(format: "%.0f", value) + "°F"
    }
    
    var windDirectionValueLabelText: String {
        guard let value = station.windDirection else { return "Not Available" }
        return String(format: "%.0f", value) + "°"
    }
    
    var windSpeedValueLabelText: String {
        guard let value = station.windSpeed else { return "Not Available" }
        return String(format: "%.0f", value) + "kts"
    }
    
    init(station: Station) {
        self.station = station
    }
    
    // MARK: - Properties
    
    private let station: Station
}
