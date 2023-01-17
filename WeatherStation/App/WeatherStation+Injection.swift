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
    static let networkService = Factory(scope: .singleton) { DefaultNetworkService() as NetworkService }
    static let urlService = Factory(scope: .singleton) { DefaultURLService() as URLService }
    static let urlSession = Factory(scope: .singleton) {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 15
        configuration.timeoutIntervalForResource = 15
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        return URLSession(configuration: configuration) as URLSessionAPI
    }
    static let weatherService = Factory(scope: .singleton) { DefaultWeatherService() as WeatherService }
}
