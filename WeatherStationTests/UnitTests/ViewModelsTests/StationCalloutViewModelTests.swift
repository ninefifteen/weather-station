//
//  StationCalloutViewModelTests.swift
//  WeatherStationTests
//
//  Created by Shawn Seals on 1/15/23.
//

import Factory
import XCTest
@testable import WeatherStation

final class StationCalloutViewModelTests: XCTestCase {
    
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_correctStrings_withNoNilValues() async throws {

        let sut = makeSUT(station: .testStation1)
        
        XCTAssertEqual(sut.stationIdValueLabelText, "K1D3")
        XCTAssertEqual(sut.stationNameValueLabelText, "PLATTE")
        XCTAssertEqual(sut.precipitationValueLabelText, "0%")
        XCTAssertEqual(sut.temperatureValueLabelText, "46°F")
        XCTAssertEqual(sut.windDirectionValueLabelText, "270°")
        XCTAssertEqual(sut.windSpeedValueLabelText, "7kts")
    }
    
    func test_correctStrings_withNilValues() async throws {

        let sut = makeSUT(station: .testStation3)
        
        XCTAssertEqual(sut.stationIdValueLabelText, "K6V4")
        XCTAssertEqual(sut.stationNameValueLabelText, "WALLMUNC")
        XCTAssertEqual(sut.precipitationValueLabelText, "Not Available")
        XCTAssertEqual(sut.temperatureValueLabelText, "Not Available")
        XCTAssertEqual(sut.windDirectionValueLabelText, "Not Available")
        XCTAssertEqual(sut.windSpeedValueLabelText, "Not Available")
    }
    
    private func makeSUT(station: Station) -> StationCalloutViewModel {
        let sut = StationCalloutViewModel(station: station)
        return sut
    }
}
