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

    let pokemonLimit = 50
    var pokemonOffset = 0

    var state = Observable<State>()
    var pokemonList: [Pokemon] = []

    private let service = Service()

//    check if is available internet connection, if true start to fetch pokemon else show error message
    func checkInternetConnection() {

        self.state.value = .loading
        if InternetConnectionManager.isConnectedToNetwork() {
            fetchPokemon()
            print("Connected")
        } else {
            self.state.value = .connectionError
            print("Not Connected")
        }
    }

//  call the service to fetch pokemon
    func fetchPokemon() {
        self.state.value = .loading
        service.fetchPokemon(limit: pokemonLimit, offset: pokemonOffset) { [weak self] success, pokemon in
            if success {
                self?.pokemonOffset += self?.pokemonLimit ?? 0
                self?.pokemonList += self?.sortPokemon(list: pokemon) ?? []
                self?.state.value = .initial
                
            } else {
                self?.state.value = .error
            }
        }
    }

//    sort the array of pokemon based on id
    func sortPokemon(list: [Pokemon]) -> [Pokemon] {
        var sortedList: [Pokemon] = list
        sortedList.sort(by: { (poke1, poke2) -> Bool in
            return poke1.id < poke2.id
        })
        return sortedList
    }
}
