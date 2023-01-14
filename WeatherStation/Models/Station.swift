//
//  Station.swift
//  WeatherStation
//
//  Created by Shawn Seals on 1/14/23.
//

import Foundation

struct WeatherStation: Codable {
    let id: String
    let name: String
    let latitude: Double
    let longitude: Double
    let temperature: Double?
    let windSpeed: Double?
    let windDirection: Double?
    let chanceOfPrecipitation: Double?
}
