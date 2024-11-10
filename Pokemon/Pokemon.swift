//
//  Pokemon.swift
//  Pokemon
//
//  Created by Masaki Sato on 2024/11/02.
//

import Foundation
import SwiftData

struct Pokemon: Decodable, Equatable, Identifiable {
    let id: UUID = UUID()
    let name: String
    let url: String
    var isFavorite: Bool = false

    init(name: String, url: String, isFavorite: Bool) {
        self.name = name
        self.url = url
        self.isFavorite = isFavorite
    }
    
    private enum CodingKeys: String, CodingKey {
        case name
        case url
    }
    
    // URLからポケモンIDを文字列として取得するプロパティ
    var pokemonIdString: String {
        return URL(string: url)?.lastPathComponent ?? ""
    }
    
    var pokemonId: Int {
        return Int(pokemonIdString) ?? 0
    }
}

struct PokemonListResponse : Decodable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Pokemon]
}
