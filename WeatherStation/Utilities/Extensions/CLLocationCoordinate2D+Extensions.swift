//
//  CLLocationCoordinate2D+Extensions.swift
//  WeatherStation
//
//  Created by Shawn Seals on 1/16/23.
//

import Foundation
import MapKit

extension CLLocationCoordinate2D {
    func isContained(in region: MKCoordinateRegion) -> Bool {
        let center = region.center
        let span = region.span
        var result = true
        result = result && cos((center.latitude - latitude) * .pi / 180.0) > cos(span.latitudeDelta / 2.0 * .pi / 180.0)
        result = result && cos((center.longitude - longitude) * .pi / 180.0) > cos(span.longitudeDelta / 2.0 * .pi / 180.0);
        return result
    }
}
