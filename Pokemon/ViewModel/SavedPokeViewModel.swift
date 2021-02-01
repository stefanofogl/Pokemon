//
//  SavedPokeViewModel.swift
//  Pokemon
//
//  Created by Stefano Foglia on 01/02/21.
//

import Foundation

class SavedPokeViewModel {
    
    enum State {
        case initial
        case loading
        case error
        case noData
    }

    private let coreData = CoreDataController.shared

    var state = Observable<State>()
    var pokemonList = [Pokemon]()
    var detailList = [PokemonDetails]()

    func fetchSavedPokemon() {
        coreData.fetchAllPokemon() { [weak self] success, pokemon, details  in
            self?.state.value = .loading
            if success {
                if pokemon.isEmpty {
                    self?.state.value = .noData
                } else {
                    self?.pokemonList = pokemon
                    self?.detailList = details
                    self?.state.value = .initial
                }
            } else {
                self?.state.value = .error
            }
        }
    }
}

