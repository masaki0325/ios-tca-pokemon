//
//  PokemonListFeature.swift
//  Pokemon
//
//  Created by Masaki Sato on 2024/11/02.
//

import Foundation
import ComposableArchitecture
import Dependencies
import SwiftData

@Reducer
struct PokemonListFeature {
    
    @Dependency(\.pokemonRepository) var repository
    @Dependency(\.favoriteRepository) var favoriteRepository
        
    @ObservableState
    struct PokemonListState : Equatable {
        var screenState: ScreenState = .initial
        var pokemons: [Pokemon] = []
        var offset = 0
        var isPagingLoading = false
        var isLoading = false
        var isRefreshing = false
    }
    
    enum Action {
        case fetchPokemons
        case pokemonsResponse(Result<PokemonListResponse, APIError>)
        case pagingNextPage
        case pagingResponse(Result<PokemonListResponse, APIError>)
        case refreshPokemons
        case refreshCompleted(Result<PokemonListResponse, APIError>)
        case toggleFavorite(Pokemon, ModelContext)
    }
    
    private enum CancelID { case load }
    
    var body: some Reducer<PokemonListState, Action> {
        Reduce { state, action in
            switch action {
                
                // Fetch
            case .fetchPokemons:
                guard !state.isLoading else { return .none }
                state.isLoading = true
                state.screenState = .loading
                return .run { send in
                    try await Task.sleep(nanoseconds: 1_500_000_000) // デモ用1.5秒の遅延
                    let result = await repository.fetchPokemons(limit: Const.limit, offset: 0)
                    await send(.pokemonsResponse(result))
                }
                
            case .pokemonsResponse(.success(let response)):
                state.isLoading = false
                state.pokemons = response.results
                state.offset = Const.limit
                state.screenState = .loaded
                return .none
                
            case .pokemonsResponse(.failure(let error)):
                state.isLoading = false
                state.screenState = .failed(error.localizedDescription)
                return .none
                
                // Paging
            case .pagingNextPage:
                guard !state.isPagingLoading else { return .none }
                state.isPagingLoading = true
                let nextOffset = state.offset
                return .run { send in
                    try await Task.sleep(nanoseconds: 1_500_000_000) // デモ用1.5秒の遅延
                    let result = await repository.fetchPokemons(limit: Const.limit, offset: nextOffset)
                    await send(.pagingResponse(result))
                }
                
            case .pagingResponse(.success(let response)):
                state.isPagingLoading = false
                state.pokemons.append(contentsOf: response.results)
                state.offset += Const.limit
                state.screenState = .loaded
                return .none
                
            case .pagingResponse(.failure(let error)):
                state.isPagingLoading = false
                state.screenState = .failed(error.localizedDescription)
                return .none
                
                // Refresh
            case .refreshPokemons:
                state.isRefreshing = true
                return .run { send in
                    try await Task.sleep(nanoseconds: 1_500_000_000) // デモ用1.5秒の遅延
                    let result = await repository.fetchPokemons(limit: Const.limit, offset: 0)
                    await send(.refreshCompleted(result))
                }
                
            case .refreshCompleted(.success(let response)):
                state.isRefreshing = false
                state.offset = Const.limit
                state.pokemons = response.results
                state.screenState = .loaded
                return .none
                
            case .refreshCompleted(.failure(let error)):
                state.isRefreshing = false
                state.screenState = .failed(error.localizedDescription)
                return .none
                
                // Favorite
            case .toggleFavorite(let pokemon, let modelContext):
                if pokemon.isFavorite {
                    favoriteRepository.deleteFavorite(pokemonId: pokemon.pokemonId, context: modelContext)
                }
                else {
                    favoriteRepository.addFavorite(pokemon: pokemon, context: modelContext)
                }
//                state.pokemons = state.pokemons.map {
//                    $0.id == pokemon.id ? Pokemon(id: $0.id, name: $0.name, isFavorite: !$0.isFavorite) : $0
//                }
                return .none
                
            }
        }
    }

}


extension PokemonListFeature {
    enum ScreenState: Equatable {
        case initial
        case loading
        case loaded
        case failed(String)
    }
    private enum Const {
        static let limit = 30
    }
}

