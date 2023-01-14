//
//  WeatherService.swift
//  WeatherStation
//
//  Created by Shawn Seals on 1/14/23.
//

import Foundation

protocol WeatherService {
    func weather(for day: Day) async throws -> [Station]
}
