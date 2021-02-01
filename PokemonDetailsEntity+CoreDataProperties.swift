//
//  PokemonDetailsEntity+CoreDataProperties.swift
//  Pokemon
//
//  Created by Stefano Foglia on 01/02/21.
//
//

import Foundation
import CoreData


extension PokemonDetailsEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PokemonDetailsEntity> {
        return NSFetchRequest<PokemonDetailsEntity>(entityName: "PokemonDetailsEntity")
    }

    @NSManaged public var attack: Int16
    @NSManaged public var defense: Int16
    @NSManaged public var firstImage: Data?
    @NSManaged public var hp: Int16
    @NSManaged public var secondImage: Data?
    @NSManaged public var specialAttack: Int16
    @NSManaged public var thirdImage: Data?
    @NSManaged public var type: String?
    @NSManaged public var weight: Int16
    @NSManaged public var pokemon: PokemonEntity?

}
