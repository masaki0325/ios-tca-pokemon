//
//  ApiClient.swift
//  Pokemon
//
//  Created by Masaki Sato on 2024/11/02.
//

import Foundation

class APIClient {
    
    private let baseURL: URL
    
    init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    func get<T: Decodable>(endpoint: String, responseType: T.Type) async -> Result<T, APIError> {
        guard let url = URL(string: endpoint, relativeTo: baseURL) else {
            return .failure(.invalidURL)
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return .success(decodedData)
        } catch let error as DecodingError {
            print("Decoding error: \(error)")
            return .failure(.decodingFailed)
        } catch let error {
            print("Request error: \(error)")
            return .failure(.unknown(error))
        }
    }
}
