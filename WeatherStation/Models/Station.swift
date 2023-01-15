//
//  Station.swift
//  WeatherStation
//
//  Created by Shawn Seals on 1/14/23.
//

import Foundation
import MapKit

struct Station: Codable, Equatable {
    let id: String
    let name: String
    let latitude: Double
    let longitude: Double
    let temperature: Double?
    let windSpeed: Double?
    let windDirection: Double?
    let chanceOfPrecipitation: Double?
}

class StationAnnotation: NSObject, MKAnnotation {
    
    init(station: Station) {
        self.station = station
    }
    
    let station: Station
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: station.latitude, longitude: station.longitude)
    }
}
