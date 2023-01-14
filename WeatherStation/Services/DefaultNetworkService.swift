//
//  DefaultNetworkService.swift
//  WeatherStation
//
//  Created by Shawn Seals on 1/14/23.
//

import Factory
import Foundation

class DefaultNetworkService: NetworkService {
    
    // MARK: - API
    
    func get(request: URLRequest) async throws -> Data {
        do {
            let (data, response) = try await urlSession.data(for: request, delegate: nil)
            try verify(response: response)
            if let jsonString = data.prettyPrintedJSONString {
                print(jsonString)
            }
            return data
        } catch {
            if let error = error as? AppError, error == .invalidResponse {
                throw error
            } else {
                throw AppError.network
            }
        }
    }
    
    // MARK: - Properties
    
    @Injected(Container.urlSession) private var urlSession: URLSessionAPI
    
    private let httpOk = 200...299
    
    // MARK: - Functions
    
    private func verify(response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse, httpOk.contains(httpResponse.statusCode) else {
            throw AppError.invalidResponse
        }
    }
}
