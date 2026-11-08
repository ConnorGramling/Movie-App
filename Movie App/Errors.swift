//
//  Errors.swift
//  Movie App
//
//  Created by Connor on 10/18/26.
//

import Foundation

enum APIConfigError: Error, LocalizedError {
    case fileNotFound
    case dataLoadingFailing(underlyingError: Error)
    case decodingFailed(underlyingError: Error)
    
    var errorDescription: String? {
        switch self {
        case .fileNotFound:
            return "API configuration file not found."
        case .dataLoadingFailing(underlyingError: let error):
            return "Failed to load data from API configuration file: \(error.localizedDescription)."
        case .decodingFailed(underlyingError: let error):
            return "Failed to decode API configuration: \(error.localizedDescription)."
        }
    }
}

enum NetworkError: Error, LocalizedError {
    case badURLResponse(underlyingError: Error)
    case missingConfig
    case urlBuildFailed
    
    var errorDescription: String? {
        switch self {
            case .badURLResponse(underlyingError: let error):
                return "Failed to parse URL response: \(error.localizedDescription)."
            case .missingConfig:
                return "Missing API Configuration."
            case .urlBuildFailed:
                return "Failed to build URL."
        }
    }
}
