//
//  PokeDetailsViewModel.swift
//  Pokemon
//
//  Created by Stefano Foglia on 01/02/21.
//

import Foundation

class PokeDetailsViewModel {
    
    private let service = Service()
    
    enum State {
        case initial
        case loading
        case error
        case successSave
        case errorSave
        case successDelete
    }

    var details: PokemonDetails?

    var state = Observable<State>()

    private let coreData = CoreDataController.shared

    func deletePokemon(id: Int) {
        coreData.deletePokemon(id: id) { [weak self] success in
            if success {
                self?.state.value = State.successDelete
            } else {
                self?.state.value = State.error
            }
        }
    }

    func savePokemon(pokemon: Pokemon) {
        let sortedKeys = details!.stats.sorted(by: { $0.0 < $1.0 })
        coreData.savePokemon(detailUrl: pokemon.detailUrl, fullName: pokemon.fullName, id: pokemon.id, mainImage: pokemon.mainImage!, attack: Int(sortedKeys[0].value)!, defense: Int(sortedKeys[1].value)!, firstImage: (details?.images[0])!, secondImage: (details?.images[1])!, thirdImage: (details?.images[2])!, hp: Int(sortedKeys[2].value)!, specialAttack: Int(sortedKeys[3].value)!, type: details!.type, weight: details!.weight) { [weak self] success in
            
            if success {
                self?.state.value = State.successSave
            } else {
                self?.state.value = State.errorSave
            }
        }
    }

    func fetchDetails(url: String) {
        self.state.value = .loading
        service.fetchDetails(url: url) { [weak self] success, details in
            if success {
                self?.details = details
                self?.state.value = .initial
            } else {
                self?.state.value = State.error
            }
        }
    }

}

