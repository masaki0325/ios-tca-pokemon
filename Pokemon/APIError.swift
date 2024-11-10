//
//  ApiError.swift
//  Pokemon
//
//  Created by Masaki Sato on 2024/11/02.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case requestFailed
    case decodingFailed
    case unknown(Error)
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .requestFailed:
            return "Request failed"
        case .decodingFailed:
            return "Decoding failed"
        case .unknown(let error):
            return "Unknown error: \(error)"
        }
    }
}
