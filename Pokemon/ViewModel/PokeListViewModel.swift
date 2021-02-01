//
//  PokeListViewModel.swift
//  Pokemon
//
//  Created by Stefano Foglia on 01/02/21.
//

import Foundation

class PokeListViewModel {

    enum State {
        case initial
        case loading
        case error
        case connectionError
    }

    let pokemonLimit = 150
    var state = Observable<State>()
    var pokemonList = [Pokemon]()

    private let service = Service()

    func checkInternetConnection() {

        self.state.value = .loading
        if InternetConnectionManager.isConnectedToNetwork() {
            fetchAllPokemon(limit: pokemonLimit)
            print("Connected")
        } else {
            self.state.value = .connectionError
            print("Not Connected")
        }
    }

    func fetchAllPokemon(limit: Int) {
        service.fetchAllPokemon(limit: limit) { [weak self] success, pokemon in
            if success {
                self?.pokemonList = self?.sortPokemon(list: pokemon) ?? []
                self?.state.value = .initial
                
            } else {
                self?.state.value = .error
            }
        }
    }

    func sortPokemon(list: [Pokemon]) -> [Pokemon] {
        var sortedList: [Pokemon] = list
        sortedList.sort(by: { (poke1, poke2) -> Bool in
            return poke1.id < poke2.id
        })
        return sortedList
    }
}
