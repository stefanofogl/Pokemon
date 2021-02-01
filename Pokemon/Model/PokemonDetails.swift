//
//  PokemonDetails.swift
//  Pokemon
//
//  Created by Stefano Foglia on 01/02/21.
//

import UIKit

class PokemonDetails {

    var images: [UIImage?]
    var fullName: String
    var type: String
    
    var stats: [String: String]
    var weight: Int
    
    init(images: [UIImage?], fullName: String, type: String, stats: [String: String], weight: Int) {
        self.images = images
        self.fullName = fullName
        self.type = type
        self.stats = stats
        self.weight = weight
    }
}
