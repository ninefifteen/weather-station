//
//  MeanOfAnglesTests.swift
//  WeatherStationTests
//
//  Created by Shawn Seals on 1/14/23.
//

import XCTest
@testable import WeatherStation

final class MeanOfAnglesTests: XCTestCase {
    
    func test_average() throws {
        let angles = [5.0, 20.0, 65.0, 50.0]
        guard let result = meanOfAngles(angles) else {
            XCTFail("result should not be nil")
            return
        }
        XCTAssertEqual(result, 35.0, accuracy: 0.01)
    }

    func test_averageOf360or0() throws {
        let angles = [350.0, 10.0]
        guard let result = meanOfAngles(angles) else {
            XCTFail("result should not be nil")
            return
        }
        XCTAssertEqual(result, 360.0, accuracy: 0.01)
    }
    
    func test_emptyArray() throws {
        let angles: [Double] = []
        let result = meanOfAngles(angles)
        XCTAssertNil(result)
    }
}
