//
//  URLSession+URLSessionAPI.swift
//  WeatherStation
//
//  Created by Shawn Seals on 1/14/23.
//

import Foundation

public protocol URLSessionAPI {
    func data(for request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionAPI {}
