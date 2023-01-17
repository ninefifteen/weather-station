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
        // MKMapView.visibleMapRect(_:animated:) does not include safe area. We add
        // add a buffer to the rect so that annotations are displayed until the point
        // is out of the user's view.
        let safeAreaCompensatingMapRect = MKMapRect(
            x: mapRect.origin.x - 0.1 * mapRect.size.width,
            y: mapRect.origin.y - 0.05 * mapRect.size.height,
            width: mapRect.size.width * 1.2,
            height: mapRect.size.height * 1.2
        )
        return safeAreaCompensatingMapRect.contains(mapPoint)
    }
}
