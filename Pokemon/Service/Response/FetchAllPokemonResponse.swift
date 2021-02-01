//
//  FetchAllPokemonResponse.swift
//  Pokemon
//
//  Created by Stefano Foglia on 01/02/21.
//

import Foundation

class FetchAllPokemonResponse: Codable {
    private enum CodingKeys: String, CodingKey {
        case results = "results"
    }
    let results: [PokemonResultsResponse]
}

class PokemonResultsResponse: Codable {
    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case url = "url"
    }
    let name: String
    let url: String
}
