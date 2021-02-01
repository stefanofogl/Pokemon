//
//  PokemonEntity+CoreDataProperties.swift
//  Pokemon
//
//  Created by Stefano Foglia on 01/02/21.
//
//

import Foundation
import CoreData


extension PokemonEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PokemonEntity> {
        return NSFetchRequest<PokemonEntity>(entityName: "PokemonEntity")
    }

    @NSManaged public var detailUrl: String?
    @NSManaged public var fullName: String?
    @NSManaged public var id: Int16
    @NSManaged public var mainImage: Data?
    @NSManaged public var details: PokemonDetailsEntity?

}
