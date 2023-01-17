//
//  StationAnnotation.swift
//  WeatherStation
//
//  Created by Shawn Seals on 1/17/23.
//

import Foundation
import MapKit

// MKAnnotation Station wrapper class.
final class StationAnnotation: NSObject, MKAnnotation {
    
    // MARK: - API
    
    init(station: Station) {
        self.station = station
    }
    
    let station: Station
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: station.latitude, longitude: station.longitude)
    }
}
