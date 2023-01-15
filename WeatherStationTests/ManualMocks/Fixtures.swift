//
//  Fixtures.swift
//  WeatherStationTests
//
//  Created by Shawn Seals on 1/14/23.
//

import Foundation

import Foundation
@testable import WeatherStation

extension Station {
    
    static let testWeather1: [Station] = [testStation1, testStation2, testStation3]
    
    static let testStation1: Station = Station(
        id: "K1D3",
        name: "PLATTE",
        latitude: 43.40332,
        longitude: -98.82952,
        temperature: 46.4,
        windSpeed: 6.90468887898,
        windDirection: 270,
        chanceOfPrecipitation: 0
    )
    
    static let testStation2: Station = Station(
        id: "K1S5",
        name: "Sunnyside Municipal Airport",
        latitude: 46.3271,
        longitude: -119.9704,
        temperature: 54.5,
        windSpeed: 9,
        windDirection: 360,
        chanceOfPrecipitation: 80
    )
    
    static let testStation3: Station = Station(
        id: "K6V4",
        name: "WALLMUNC",
        latitude: 43.99949,
        longitude: -102.2546,
        temperature: nil,
        windSpeed: nil,
        windDirection: nil,
        chanceOfPrecipitation: 0
    )
}

extension Data {
    static let testWeather1: Data = {
        let bundle = Bundle(for: DefaultNetworkServiceTests.self)
        let url = bundle.url(forResource: "testWeather1", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        return data
    }()
}
