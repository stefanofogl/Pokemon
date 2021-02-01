//
//  APIEndpoints.swift
//  Pokemon
//
//  Created by Stefano Foglia on 01/02/21.
//

import Foundation

public struct APIEndpoints {
    
    // Base Url for all calls
    private static let baseUrl = "https://pokeapi.co/api/v2/"
    
    // Endpoint to fetch all pokemon
    static let fetchAllPokemon = baseUrl + "pokemon/?offset="
    
    // Endpoint to fetch pokemon details
    static let fetchPokemonDetail = baseUrl + "pokemon/"
    
    // Endpoint to fetch images
    static let fetchImage = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/"
    
}
