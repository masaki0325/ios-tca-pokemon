//
//  FavoritePokemonRepository.swift
//  Pokemon
//
//  Created by Masaki Sato on 2024/11/06.
//

import Foundation
import SwiftData
import Dependencies

class FavoritePokemonRepository : FavoritePokemonRepositoryProtocol {
    
    // お気に入り追加
    func addFavorite(pokemon: Pokemon, context: ModelContext) {
        if isFavorite(pokemonId: pokemon.pokemonId, context: context) {
            return
        }
        let favorite = FavoritePokemon(pokemonId: pokemon.pokemonId, name: pokemon.name, url: pokemon.url)
        context.insert(favorite)
        try? context.save()
    }
    
    // お気に入り削除
    func deleteFavorite(pokemonId: Int, context: ModelContext) {
        let descriptor = FetchDescriptor<FavoritePokemon>()
        if let favorites = try? context.fetch(descriptor).filter({ $0.pokemonId == pokemonId }) {
            favorites.forEach { context.delete($0) }
            try? context.save()
        }
    }
    
    // お気に入り取得
    func fetchFavorites(context: ModelContext) -> [FavoritePokemon] {
        let descriptor = FetchDescriptor<FavoritePokemon>()
        return (try? context.fetch(descriptor)) ?? []
    }
    
    // お気に入りかどうか
    func isFavorite(pokemonId: Int, context: ModelContext) -> Bool {
        let request = FetchDescriptor<FavoritePokemon>(
            predicate: #Predicate { $0.pokemonId == pokemonId }
        )
        do {
            let results = try context.fetch(request)
            return !results.isEmpty
        } catch {
            print("Error checking favorite existence: \(error)")
            return false
        }
    }
}

protocol FavoritePokemonRepositoryProtocol {
    func addFavorite(pokemon: Pokemon, context: ModelContext)
    func deleteFavorite(pokemonId: Int, context: ModelContext)
    func fetchFavorites(context: ModelContext) -> [FavoritePokemon]
}

extension DependencyValues {
    var favoriteRepository: FavoritePokemonRepositoryProtocol {
        get { self[FavoritePokemonRepositoryKey.self.self] }
        set { self[FavoritePokemonRepositoryKey.self.self] = newValue }
    }
    private enum FavoritePokemonRepositoryKey: DependencyKey {
         static let liveValue: FavoritePokemonRepositoryProtocol = FavoritePokemonRepository()
    }
}
