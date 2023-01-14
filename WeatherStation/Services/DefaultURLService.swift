//
//  DefaultURLService.swift
//  WeatherStation
//
//  Created by Shawn Seals on 1/14/23.
//

import Foundation

struct DefaultURLService: URLService {
    
    // MARK: - API
    
    func makeURL(for day: Day) throws -> URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = basePath + endpoint(for: day)
        
        guard let url = urlComponents.url else {
            preconditionFailure("DefaultURLService failed to form valid URL.")
        }
        return url
    }
    
    // MARK: - Constants
    
    private let scheme = "https"
    private let host = "gist.githubusercontent.com"
    private let basePath = "/rcedwards/"
    private let todayEndpoint = "4ff0a1510551295be0ec0369186d83ed/raw/fc7b5308546c0e1085d8748134138cef4281ac11/today.json"
    private let tomorrowEndpoint = "6421fa7f0f3789801935d6d37df55922/raw/e673021836819aa20018853643c8769fd4d129fd/tomorrow.json"
    
    // MARK: - Functions
    
    private func endpoint(for day: Day) -> String {
        switch day {
        case .today:
            return todayEndpoint
        case .tomorrow:
            return tomorrowEndpoint
        }
    }
}
