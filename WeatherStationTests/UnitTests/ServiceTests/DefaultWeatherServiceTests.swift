//
//  DefaultWeatherServiceTests.swift
//  WeatherStationTests
//
//  Created by Shawn Seals on 1/14/23.
//

import Factory
import Mockingbird
import XCTest
@testable import WeatherStation

final class DefaultWeatherServiceTests: XCTestCase {
    
    private var networkServiceMock: NetworkServiceMock!
    
    override func setUp() {
        super.setUp()
        networkServiceMock = mock(NetworkService.self)
        Container.networkService.register { self.networkServiceMock }
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_getWeather_successful() async throws {
        
        let sut = makeSUT()
        
        await given(networkServiceMock.get(request: any())).willReturn(Data.testWeather1)
        let weather = try await sut.weather(for: .today)

        XCTAssertEqual(weather, Station.testWeather1)
    }
    
    func test_getWeather_dataNotDecodable_throws() async throws {

        let sut = makeSUT()

        await given(networkServiceMock.get(request: any())).willReturn(Data())

        await XCTAssertThrowsError(
            try await sut.weather(for: .today),
            "AppError.decoder should be thown"
        ) { error in
            XCTAssertEqual(
                error as? AppError,
                AppError.decoder,
                "AppError.decoder should be thown"
            )
        }
    }
    
    private func makeSUT() -> DefaultWeatherService {
        let sut = DefaultWeatherService()
        return sut
    }
    
    private var mockUrl: URL { URL(string: "www.google.com")! }
    private var mockRequest: URLRequest { URLRequest(url: mockUrl) }
    
}

private class MockNetworkService: NetworkService {
    
    init(error: Error) {
        self.error = error
    }
    
    func get(request: URLRequest) async throws -> Data {
        throw error
    }
    
    private let error: Error
}
