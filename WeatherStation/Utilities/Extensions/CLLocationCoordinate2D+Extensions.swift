//
//  CLLocationCoordinate2D+Extensions.swift
//  WeatherStation
//
//  Created by Shawn Seals on 1/16/23.
//

import Foundation
import MapKit

extension CLLocationCoordinate2D {
    func isContained(in mapRect: MKMapRect) -> Bool {
        let mapPoint = MKMapPoint(self)
        return mapRect.contains(mapPoint)
    }
}
