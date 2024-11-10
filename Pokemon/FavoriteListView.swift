//
//  FavoriteListView.swift
//  Pokemon
//
//  Created by Masaki Sato on 2024/11/06.
//

import SwiftUI
import ComposableArchitecture
import Dependencies
import SwiftData

struct FavoriteListView: View {
    let store: StoreOf<FavoriteListFeature>

    @Query private var favorites: [FavoritePokemon]

    var body: some View {
        List {
            ForEach(favorites) { favorite in
                Text(favorite.name)
            }
        }.navigationTitle("お気に入り")
    }
}

