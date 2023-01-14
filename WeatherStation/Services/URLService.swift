//
//  URLService.swift
//  WeatherStation
//
//  Created by Shawn Seals on 1/14/23.
//

import Foundation

protocol URLService {
    func makeURL(for day: Day) throws -> URL
}
