//
//  FavoriteListFeature.swift
//  Pokemon
//
//  Created by Masaki Sato on 2024/11/06.
//

import Foundation
import ComposableArchitecture
import Dependencies
import SwiftData

@Reducer
struct FavoriteListFeature {

    @Dependency(\.favoriteRepository) var favoriteRepository

    @ObservableState
    struct FavoriteListState : Equatable {
        var favorites: [FavoritePokemon] = []
    }
    
    enum Action {
    }
        
    var body: some Reducer<FavoriteListState, Action> {
        Reduce { state, action in
            switch action {
            }
        }
    }

}
