//
//  FavoritePokemon.swift
//  Pokemon
//
//  Created by Masaki Sato on 2024/11/06.
//

import Foundation
import SwiftData

@Model
class FavoritePokemon {
    var pokemonId: Int
    var name: String
    var url: String
    
    init(pokemonId: Int, name: String, url: String) {
        self.pokemonId = pokemonId
        self.name = name
        self.url = url
    }
}
