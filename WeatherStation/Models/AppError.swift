//
//  AppError.swift
//  WeatherStation
//
//  Created by Shawn Seals on 1/14/23.
//

import Foundation

enum AppError: Error, Equatable {
    case decoder
    case invalidResponse
    case network
    case unknown
}

extension AppError {
    
    var alertTitle: String {
        switch self {
        case .decoder:
            return "Decoding Error"
        case .invalidResponse:
            return "Invalid Response"
        case .network:
            return "Network Failure"
        case .unknown:
            return "Unknown Error"
        }
    }
    
    var alertMessage: String {
        switch self {
        case .decoder:
            return "The data received from the server was invalid. Please try again."
        case .invalidResponse:
            return "Invalid response received from the server. Please try again."
        case .network:
            return "Unable to complete your request. Please check your internet connection or try again later."
        case .unknown:
            return "Well this is embarassing. We don't know what happened."
        }
    }
}
