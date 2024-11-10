//
//  PokemonDetailFeature.swift
//  Pokemon
//
//  Created by Masaki Sato on 2024/11/02.
//

import Foundation
import ComposableArchitecture
import Dependencies

@Reducer
struct PokemonDetailFeature {
    
    @Dependency(\.pokemonRepository) var repository

    @ObservableState
    struct PokemonDetailState : Equatable {
        var screenState: ScreenState = .initial
        var pokemonId: Int
        var pokemonDetail: PokemonDetail?
        var isLoading: Bool = false
    }
    
    enum Action {
        case fetchPokemonDetail(pokemonId: Int)
        case pokemonDetailResponse(Result<PokemonDetail, APIError>)
    }
    
    var body: some Reducer<PokemonDetailState, Action> {
        Reduce { state, action in
            switch action {
            case .fetchPokemonDetail(let pokemonId):
                state.isLoading = true
                state.screenState = .loading
                return .run { send in
                    let result = await repository.fetchPokemonDetail(pokemonId: pokemonId)
                    await send(.pokemonDetailResponse(result))
                }
            case .pokemonDetailResponse(.success(let response)):
                state.isLoading = false
                state.pokemonDetail = response
                state.screenState = .success
                return .none
            case .pokemonDetailResponse(.failure(let error)):
                state.screenState = .failed(error.localizedDescription)
                return .none
            }
        }
    }
}

extension PokemonDetailFeature {
    enum ScreenState: Equatable {
        case initial
        case loading
        case success
        case failed(String)
    }
}
