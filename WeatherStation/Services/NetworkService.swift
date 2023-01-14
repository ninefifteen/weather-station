//
//  NetworkService.swift
//  WeatherStation
//
//  Created by Shawn Seals on 1/14/23.
//

import Foundation

protocol NetworkService {
    func get(request: URLRequest) async throws -> Data
}
