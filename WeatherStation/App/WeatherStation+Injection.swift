//
//  WeatherStation+Injection.swift
//  WeatherStation
//
//  Created by Shawn Seals on 1/14/23.
//

import Foundation

import Factory
import Foundation

extension Container {
    static let networkService = Factory { DefaultNetworkService() as NetworkService }
    static let urlService = Factory { DefaultURLService() as URLService }
    static let urlSession = Factory { URLSession(configuration: .default) as URLSessionAPI }
    static let weatherService = Factory { DefaultWeatherService() as WeatherService }
}
