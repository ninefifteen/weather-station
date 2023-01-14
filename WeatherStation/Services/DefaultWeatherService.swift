//
//  DefaultWeatherService.swift
//  WeatherStation
//
//  Created by Shawn Seals on 1/14/23.
//

import Factory
import Foundation

class DefaultWeatherService: WeatherService {

    // MARK: - API
    
    func weather(for day: Day) async throws -> [Station] {
        let url = try urlService.makeURL(for: day)
        let data = try await networkService.get(request: URLRequest(url: url))
        return try decode(data: data)
    }
    
    // MARK: - Properties
    
    @Injected(Container.networkService) private var networkService: NetworkService
    @Injected(Container.urlService) private var urlService: URLService
    
    private lazy var jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    // MARK: - Functions
    
    private func decode<T: Decodable>(data: Data) throws -> T {
        do {
            let value = try jsonDecoder.decode(T.self, from: data)
            return value
        } catch {
            throw AppError.decoder
        }
    }
}
