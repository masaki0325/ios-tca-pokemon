//
//  PokemonDetailView.swift
//  Pokemon
//
//  Created by Masaki Sato on 2024/11/02.
//

import SwiftUI
import ComposableArchitecture
import Dependencies

struct PokemonDetailView: View {
    let store: StoreOf<PokemonDetailFeature>
    let pokemonId: Int
    
    var body: some View {
        switch store.screenState {
        case .initial:
            Color.clear.onAppear {
                Task {
                    store.send(.fetchPokemonDetail(pokemonId: pokemonId))
                }
            }
        case .loading:
            ProgressView()
        case .success:
            if let detail = store.pokemonDetail {
                ContentView(pokemonDetail: detail)
            }
        case .failed(let message):
            ErrorView(message: message) {
                store.send(.fetchPokemonDetail(pokemonId: pokemonId))
            }
        }
    }
}

private struct ContentView: View {
    let pokemonDetail: PokemonDetail
    
    var body: some View {
        VStack {
            Text(pokemonDetail.name)
                .font(.largeTitle)
                .padding()
            
            Text("height: \(pokemonDetail.height)m").padding()
            Text("weight: \(pokemonDetail.weight)kg").padding()
            
            if let imageUrl = URL(string: pokemonDetail.sprites.frontDefault) {
                AsyncImage(url: imageUrl) { image in
                    image.resizable()
                        .frame(width: 300, height: 300)
                } placeholder: {
                    ProgressView()
                }
            }
        }
    }
}

#Preview {
    ContentView(pokemonDetail: PokemonDetail(
        id: 25,
        name: "Pikachu",
        height: 100,
        weight: 100,
        sprites: Sprites(frontDefault: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/25.png")
    ))
}
