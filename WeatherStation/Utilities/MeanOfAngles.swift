//
//  MeanOfAngles.swift
//  WeatherStation
//
//  Created by Shawn Seals on 1/14/23.
//  https://rosettacode.org/wiki/Averages/Mean_angle
//

import Foundation

@inlinable func d2r<T: FloatingPoint>(_ f: T) -> T { f * .pi / 180 }
@inlinable func r2d<T: FloatingPoint>(_ f: T) -> T { f * 180 / .pi }

// Note: In some scenarios, the mean returned by this function is meaningless in the context of the
// Weather Station app. For example: [90.0, 270.0] will return 180.0. By using this function anyway,
// I am making the assumption that for a user's common level of zoom, the stations that are averaged
// will have at least somewhat similar wind directions making the functions result useful.
public func meanOfAngles(_ angles: [Double]) -> Double? {
    guard angles.count > 0 else { return nil }
    let cInv = 1 / Double(angles.count)
    let (s, c) =
    angles.lazy
        .map(d2r)
        .map({ (sin($0), cos($0)) })
        .reduce(into: (0.0, 0.0), { $0.0 += $1.0; $0.1 += $1.1 })
    let angle = r2d(atan2(cInv * s, cInv * c))
    return angle > 0.0 ? angle : 360 + angle
}
