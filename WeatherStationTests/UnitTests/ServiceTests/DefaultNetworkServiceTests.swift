//
//  DefaultNetworkServiceTests.swift
//  WeatherStationTests
//
//  Created by Shawn Seals on 1/14/23.
//

import Factory
import Mockingbird
import XCTest
@testable import WeatherStation

final class DefaultNetworkServiceTests: XCTestCase {
    
    private var urlSessionMock: URLSessionAPIMock!
    
    override func setUp() {
        super.setUp()
        urlSessionMock = mock(URLSessionAPI.self)
        Container.urlSession.register { self.urlSessionMock }
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_get_successful() async throws {
        
        let sut = makeSUT()
        let response = HTTPURLResponse(
            url: mockUrl,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        await given(urlSessionMock.data(for: any(), delegate: any()))
            .willReturn((Data(), response!))
        
        let data = try await sut.get(request: mockRequest)
        
        XCTAssertNotNil(data, "data should not be nil")
    }
    
    func test_get_non200statusCode_throws() async throws {
        
        let sut = makeSUT()
        let response = HTTPURLResponse(
            url: mockUrl,
            statusCode: 404,
            httpVersion: nil,
            headerFields: nil
        )
        
        await given(urlSessionMock.data(for: any(), delegate: any()))
            .willReturn((Data(), response!))
                
        await XCTAssertThrowsError(
            try await sut.get(request: mockRequest),
            "AppError.invalidResponse should be thrown"
        ) { error in
            XCTAssertEqual(
                error as? AppError,
                AppError.invalidResponse,
                "AppError.invalidResponse should be thrown"
            )
        }
    }
    
    func test_get_urlSessionError_throws() async throws {

        enum MockError: Error {
            case unknown
        }
        
        Container.urlSession.register { MockErrorURLSession(error: MockError.unknown) }
        
        let sut = makeSUT()

        await XCTAssertThrowsError(
            try await sut.get(request: mockRequest),
            "AppError.network should be thrown"
        ) { error in
            XCTAssertEqual(
                error as? AppError,
                AppError.network,
                "AppError.network should be thrown"
            )
        }
    }
    
    private func makeSUT() -> DefaultNetworkService {
        let sut = DefaultNetworkService()
        return sut
    }
    
    private var mockUrl: URL { URL(string: "www.google.com")! }
    private var mockRequest: URLRequest { URLRequest(url: mockUrl) }
    
}

private class MockErrorURLSession: URLSessionAPI {
    
    init(error: Error) {
        self.error = error
    }
    
    func data(for request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse) {
        throw error
    }
    
    private let error: Error
}
