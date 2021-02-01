//
//  Service.swift
//  Pokemon
//
//  Created by Stefano Foglia on 01/02/21.
//

import Foundation
import UIKit

protocol ServiceProtocol {

    typealias fetchAllPokemonCompletion = (_ success: Bool, _ pokemon: [Pokemon]) -> Void
    typealias fetchImageCompletion = (_ success: Bool, _ image: UIImage?) -> Void
    typealias createPokemonCompletion = (_ success: Bool, _ pokemon: [Pokemon]) -> Void
    typealias createPokemonDetailCompletion = (_ success: Bool, _ pokemon: PokemonDetails?) -> Void
    typealias fetchPokemonDetailsCompletion = (_ success: Bool, _ pokemon: PokemonDetails?) -> Void
    
    func fetchPokemon( limit: Int, offset: Int, _ completion: @escaping fetchAllPokemonCompletion)
    func fetchDetails(url: String, completion: @escaping fetchPokemonDetailsCompletion)
    
}

class Service: ServiceProtocol {

    func fetchPokemon(limit: Int, offset: Int, _ completion: @escaping fetchAllPokemonCompletion) {

        var request = URLRequest(url: URL(string: APIEndpoints.fetchAllPokemon + "\(offset)" + "&limit=\(limit)")!)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                completion(false, [])
                return
            }
            do {
                let res = try JSONDecoder().decode(FetchAllPokemonResponse.self, from: data)
                guard offset <= res.count else { return }

                self.pokemonFrom(res.results, offset: offset, limit: limit) { success, pokemon in
                    if success {
                        completion(true, pokemon)
                    } else {
                       completion(false, [])
                    }
                }
                
            } catch let error {
                completion(false, [])
                print(error)
            }
        }
        
        task.resume()
    }

    func fetchDetails(url: String, completion: @escaping(fetchPokemonDetailsCompletion)) {
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                completion(false, nil)
                return
            }
            do {
                let res = try JSONDecoder().decode(FetchDetailResponse.self, from: data)

                self.pokemonDetailFrom(res) { success, details in
                    if success {
                        completion(true, details)
                    } else {
                       completion(false, nil)
                    }
                }
                
            } catch let error {
                completion(false, nil)
                print(error)
            }
        }
        
        task.resume()

    }

    private func fetchImage(url: String, completion: @escaping(fetchImageCompletion)) {
        guard let url = URL(string: url) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                print("Failed to fetch image with error: ", error.localizedDescription)
                completion(false, nil)
                return
            }
            guard let data = data else {
                completion(false, nil)
                return
            }
            guard let image = UIImage(data: data) else {
                completion(false, nil)
                return
            }
            completion(true, image)
            
        }.resume()
    }

    private func pokemonFrom(_ object: [PokemonResultsResponse], offset: Int, limit: Int, completion: @escaping(createPokemonCompletion)) {
        
//        create pokemon object from response
        var tmp = [Pokemon]()
        var imageId = offset
        var pokeId = offset
        for i in object {
            imageId = imageId + 1
            fetchImage(url: APIEndpoints.fetchImage + "\(imageId).png") { success, image in
                if success {
                    pokeId = pokeId + 1
                    let pokemon = Pokemon(id: pokeId, image: image, fullName: i.name, detailUrl: i.url)
                    tmp.append(pokemon)
                    if pokeId == offset + limit {
                        completion(true, tmp)
                    }
                } else {
                    completion(false, [])
                    return
                }
            }
            
        }
    }

    private func pokemonDetailFrom(_ object: FetchDetailResponse, completion: @escaping(createPokemonDetailCompletion)) {
        
        let urlImages = [object.images.frontDefault, object.images.backDefault, object.images.frontShiny, object.images.backShiny]
        
        var stats: [String: String] = [:]
        for stat in object.stats {
            stats[stat.stat.name] = String(stat.value)
        }
        
        var images = [UIImage]()
        
        for img in urlImages {
            fetchImage(url: img) { success, image in
                if success {
                    images.append(image ?? UIImage())
                    let details = PokemonDetails(images: images, fullName: object.name, type: object.types.first?.type.name ?? "", stats: stats, weight: object.weight)
                    completion(true, details)
                } else {
                    completion(false, nil)
                    return
                }
            }

        }
    }

}
