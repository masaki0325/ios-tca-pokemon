//
//  PokemonListView.swift
//  Pokemon
//
//  Created by Masaki Sato on 2024/11/01.
//

import SwiftUI
import ComposableArchitecture
import Dependencies

struct PokemonListView: View {
    let store: StoreOf<PokemonListFeature>

    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationStack {
            switch store.screenState {
            case .initial:
                Color.clear.onAppear {
                    store.send(.fetchPokemons)
                }
            case .loading:
                ProgressView()
            case .loaded:
                ListView(
                    pokemons: store.pokemons,
                    isPagingLoading: store.isPagingLoading,
                    fetchNextPage: {
                        store.send(.pagingNextPage)
                    },
                    refresh: {
                        store.send(.refreshPokemons)
                    },
                    toggleFavorite: { pokemon in
                        store.send(.toggleFavorite(pokemon, modelContext))
                    }
                )
                .navigationTitle("Pokemon List")
            case .failed(let message):
                ErrorView(message: message) {
                    store.send(.fetchPokemons)
                }
            }
        }
    }
}


struct ListView: View {
    let pokemons: [Pokemon]
    let isPagingLoading: Bool
    let fetchNextPage: () -> Void
    let refresh: () -> Void
    let toggleFavorite: (Pokemon) -> Void

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(pokemons) { pokemon in
                    ListItemView(
                        pokemon: pokemon,
                        didTapItem: { pokemon in
                            print("Tapped on \(pokemon.name)")
                        },
                        toggleFavorite: { pokemon in
                            toggleFavorite(pokemon)
                        }
                    )
                    .onAppear {
                        if pokemon == pokemons.last {
                            fetchNextPage()
                        }
                    }
                }
            }
            if isPagingLoading {
                ProgressView().padding()
            }
        }
        .refreshable {
            do {
                try await Task.sleep(nanoseconds: 1_000_000_000)
                refresh()
            } catch {
                print("Error")
            }
        }
    }
}

struct ListItemView: View {
    let pokemon: Pokemon
    let didTapItem: (Pokemon) -> Void
    let toggleFavorite: (Pokemon) -> Void

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer().frame(width: 6)
                Text(pokemon.pokemonIdString)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Spacer().frame(width: 16)
                Text(pokemon.name.capitalized)
                    .font(.headline)
                    .foregroundColor(.black)
                Spacer()
                Button(action: {
                    toggleFavorite(pokemon)
                }) {
                    Image(systemName: pokemon.isFavorite ? SFSymbols.starFilled : SFSymbols.star)
                        .foregroundColor(pokemon.isFavorite ? .yellow : .gray)
                }
                Spacer().frame(width: 16)
            }
            .frame(height: 50)
            .padding(.horizontal, 8)
            .background(Color.white)
            
            Divider()
        }.onTapGesture {
            didTapItem(pokemon)
        }
    }
}

#Preview {
    ListView(
        pokemons: [
            Pokemon(name: "bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/", isFavorite: true),
            Pokemon(name: "ivysaur", url: "https://pokeapi.co/api/v2/pokemon/2/", isFavorite: false),
            Pokemon(name: "venusaur", url: "https://pokeapi.co/api/v2/pokemon/3/", isFavorite: false)
        ],
        isPagingLoading: false,
        fetchNextPage: {},
        refresh: {},
        toggleFavorite: { _ in }
    )
}
