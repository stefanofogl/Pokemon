//
//  FetchDetailResponse.swift
//  Pokemon
//
//  Created by Stefano Foglia on 01/02/21.
//

import Foundation

class FetchDetailResponse: Codable {
    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case types = "types"
        case weight = "weight"
        case stats = "stats"
        case images = "sprites"
    }
    let name: String
    let weight: Int
    let types: [TypesResponse]
    let stats: [StatsResponse]
    let images: SpritesResponse
    
}

class SpritesResponse: Codable {
    private enum CodingKeys: String, CodingKey {
        case backDefault = "back_default"
        case frontDefault = "front_default"
        case frontShiny = "front_shiny"
        case backShiny = "back_shiny"
    }
    let backDefault: String
    let frontDefault: String
    let frontShiny: String
    let backShiny: String
}

class TypesResponse: Codable {
    private enum CodingKeys: String, CodingKey {
        case type = "type"
    }
    let type: TypeResponse
}

class TypeResponse: Codable {
    private enum CodingKeys: String, CodingKey {
        case name = "name"
    }
    let name: String
}

class StatsResponse: Codable {
    private enum CodingKeys: String, CodingKey {
        case value = "base_stat"
        case stat = "stat"
    }
    let value: Int
    let stat: StatResponse
}

class StatResponse: Codable {
    private enum CodingKeys: String, CodingKey {
        case name = "name"
    }
    let name: String
}
