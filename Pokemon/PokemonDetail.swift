//
//  PokemonDetail.swift
//  Pokemon
//
//  Created by Masaki Sato on 2024/11/02.
//

import Foundation

struct PokemonDetail: Decodable, Equatable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let sprites: Sprites
}

struct Sprites: Decodable, Equatable {
    let frontDefault: String

    private enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

struct PokemonDetailResponse : Decodable {
    let detail: PokemonDetail
}
