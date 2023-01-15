//
//  Array+Extensions.swift
//  WeatherStation
//
//  Created by Shawn Seals on 1/14/23.
//

import Foundation

extension Array where Element == Double {
    
    func averageValue() -> Double? {
        guard count > 0 else { return nil }
        return reduce(0, +) / Double(count)
    }
}

extension Array where Element == Station {
    
    func averageTemperature() -> Double? {
        compactMap({ $0.temperature }).averageValue()
    }
    
    func averageWindSpeed() -> Double? {
        compactMap({ $0.windSpeed }).averageValue()
    }
    
    func averageWindDirection() -> Double? {
        let angles = compactMap { $0.windSpeed }
        guard angles.count > 0 else { return nil }
        return meanOfAngles(angles)
    }
    
    func averageChanceOfPercipitation() -> Double? {
        compactMap({ $0.chanceOfPrecipitation }).averageValue()
    }
}
