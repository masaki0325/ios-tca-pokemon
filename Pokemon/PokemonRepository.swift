//
//  PokemonRepository.swift
//  Pokemon
//
//  Created by Masaki Sato on 2024/11/02.
//

import Foundation
import Dependencies

// リポジトリの実装
class PokemonRepository: PokemonRepositoryProtocol {
    
    func fetchPokemons(limit: Int, offset: Int) async -> Result<PokemonListResponse, APIError> {
        guard let url = URL(string: "https://pokeapi.co/api/v2/") else {
            return .failure(.invalidURL)
        }
        let apiClient = APIClient(baseURL: url)
        let endpoint = "pokemon?limit=\(limit)&offset=\(offset)"
        let result = await apiClient.get(endpoint: endpoint, responseType: PokemonListResponse.self)

        switch result {
            case .success(let response):
                print("Fetched Pokemon list: \(response.results)")
                return .success(response)
            case .failure(let error):
                print("Failed to fetch Pokemon list: \(error)")
                return .failure(error)
        }
    }
    
    func fetchPokemonDetail(pokemonId: Int) async -> Result<PokemonDetail, APIError> {
        guard let url = URL(string: "https://pokeapi.co/api/v2/") else {
            return .failure(.invalidURL)
        }
        let apiClient = APIClient(baseURL: url)
        let result = await apiClient.get(endpoint: "pokemon/\(pokemonId)", responseType: PokemonDetail.self)

        switch result {
            case .success(let response):
                print("Fetched Pokemon detail: \(response)")
                return .success(response)
            case .failure(let error):
                print("Failed to fetch Pokemon detail: \(error)")
                return .failure(error)
        }
    }
    
}


protocol PokemonRepositoryProtocol {
    func fetchPokemons(limit: Int, offset: Int) async -> Result<PokemonListResponse, APIError>
    func fetchPokemonDetail(pokemonId: Int) async -> Result<PokemonDetail, APIError>
}

extension DependencyValues {
    var pokemonRepository: PokemonRepositoryProtocol {
        get { self[PokemonRepositoryKey.self.self] }
        set { self[PokemonRepositoryKey.self.self] = newValue }
    }
    private enum PokemonRepositoryKey: DependencyKey {
         static let liveValue: PokemonRepositoryProtocol = PokemonRepository()
    }
}
