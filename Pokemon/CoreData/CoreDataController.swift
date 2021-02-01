//
//  CoreDataController.swift
//  Pokemon
//
//  Created by Stefano Foglia on 01/02/21.
//

import Foundation
import CoreData
import UIKit

protocol CoreDataProtocol {
    typealias fetchAllPokemonCompletion = (_ success: Bool, _ pokemon: [Pokemon], _ details: [PokemonDetails]) -> Void
    typealias saveContextCompletion = (_ success: Bool) -> Void
    typealias deletePokemonCompletion = (_ success: Bool) -> Void
    typealias savePokemonCompletion = (_ success: Bool) -> Void
    typealias pokemonFromRequestCompletion = (_ success: Bool, _ pokemon: [PokemonEntity]) -> Void
    typealias loadPokemonFromIdCompletion = (_ success: Bool, _ pokemon: PokemonEntity?) -> Void
}

class CoreDataController: CoreDataProtocol {
    static let shared = CoreDataController()
    
    private var context: NSManagedObjectContext
    
    private init() {
        let application = UIApplication.shared.delegate as! AppDelegate
        self.context = application.persistentContainer.viewContext
    }
    
    private func saveContext(_ completion: @escaping saveContextCompletion) {
        do {
            try self.context.save()
            completion(true)
        } catch let error {
            print(error)
            completion(false)
        }
    }
    
    func fetchAllPokemon( _ completion: @escaping fetchAllPokemonCompletion) {
        
        let fetchRequest: NSFetchRequest<PokemonEntity> = PokemonEntity.fetchRequest()
        fetchRequest.returnsObjectsAsFaults = false
        
        loadPokemonFromFetchRequest(request: fetchRequest) { success, entity in
            if success {
                let pokemon = self.pokemonFrom(entity)
                let details = self.detailsFrom(entity)
                completion(true, pokemon, details)
            } else {
                completion(false, [], [])
            }
        }
    }
    
    func deletePokemon(id: Int, _ completion: @escaping deletePokemonCompletion) {
        self.loadPokemonFromId(id: id) { success, pokemon in
            guard pokemon != nil else {
                completion(false)
                return
            }
            if success {
                self.context.delete(pokemon!)
                self.saveContext() { success in
                    if success {
                        completion(true)
                    } else {
                        completion(false)
                    }
                }
            } else {
                completion(false)
            }
        }
    }
    
    func savePokemon(detailUrl: String, fullName: String, id: Int, mainImage: UIImage, attack: Int, defense: Int, firstImage: UIImage, secondImage: UIImage, thirdImage: UIImage, hp: Int, specialAttack: Int, type: String, weight: Int, _ completion: @escaping savePokemonCompletion) {
        let entity = NSEntityDescription.entity(forEntityName: "PokemonEntity", in: self.context)
        
        let pokemon = PokemonEntity(entity: entity!, insertInto: self.context)
        let entityDeatil = NSEntityDescription.entity(forEntityName: "PokemonDetailsEntity", in: self.context)
        let details = PokemonDetailsEntity(entity: entityDeatil!, insertInto: context)
        
        details.pokemon = pokemon
        details.attack = Int16(attack)
        details.defense = Int16(defense)
        details.hp = Int16(hp)
        details.specialAttack = Int16(specialAttack)
        details.type = type
        details.weight = Int16(weight)
        details.firstImage = firstImage.pngData()
        details.secondImage = secondImage.pngData()
        details.thirdImage = thirdImage.pngData()
        
        pokemon.detailUrl = detailUrl
        pokemon.fullName = fullName
        pokemon.id = Int16(id)
        pokemon.mainImage = mainImage.pngData()
        
        self.saveContext() { success in
            if success {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    private func loadPokemonFromFetchRequest(request: NSFetchRequest<PokemonEntity>, _ completion: @escaping pokemonFromRequestCompletion) {
        var array = [PokemonEntity]()
        do {
            array = try self.context.fetch(request)
            guard array.count > 0 else {
                print("error no data ")
                completion(true, [])
                return
            }
        } catch let error {
            completion(false, [])
            print(error)
        }
        completion(true, array)
    }
    
    private func loadPokemonFromId(id: Int, _ completion: @escaping loadPokemonFromIdCompletion) {
        let request: NSFetchRequest<PokemonEntity> = NSFetchRequest(entityName: "PokemonEntity")
        request.returnsObjectsAsFaults = false
        
        let predicate = NSPredicate(format: "id == \(id)")
        request.predicate = predicate
        
        self.loadPokemonFromFetchRequest(request: request) { success, pokemon in
            if success {
                completion(true, pokemon[0])
            } else {
                completion(false, nil)
            }
        }
    }

    private func pokemonFrom(_ entity: [PokemonEntity]) -> [Pokemon] {
        var tmp : [Pokemon] = []
        for poke in entity {
            if let image = UIImage(data: poke.mainImage!) {
                let pokemon = Pokemon(id: Int(poke.id), image: image, fullName: poke.fullName ?? "", detailUrl: poke.detailUrl ?? "")
                tmp.append(pokemon)
            }
        }
        return tmp
    }

    private func detailsFrom(_ entity: [PokemonEntity]) -> [PokemonDetails] {
        var tmp : [PokemonDetails] = []
        for poke in entity {
            let detail = poke.details
            let firstImage = UIImage(data: (detail?.firstImage)!)
            let secondImage = UIImage(data: (detail?.secondImage)!)
            let thirdImage = UIImage(data: (detail?.thirdImage)!)
            let attack = String(detail!.attack)
            let defense = String(detail!.defense)
            let hp = String(detail!.hp)
            let specialAttack = String(detail!.specialAttack)
            let stats : [String : String] = ["Attack" : attack, "Defense" : defense, "Hp" : hp, "Special-Attack" : specialAttack]
            let images : [UIImage?] = [firstImage, secondImage, thirdImage]
            let details = PokemonDetails(images: images, fullName: poke.fullName ?? "", type: detail?.type ?? "", stats: stats, weight: Int(detail!.weight))
            tmp.append(details)
        }
        return tmp
    }
}
