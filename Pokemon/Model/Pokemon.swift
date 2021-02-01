//
//  Pokemon.swift
//  Pokemon
//
//  Created by Stefano Foglia on 01/02/21.
//

import UIKit

class Pokemon {

    var id: Int
    var mainImage: UIImage?
    var fullName: String
    var detailUrl: String
    
    init(id: Int, image: UIImage?, fullName: String, detailUrl: String) {
        self.id = id
        self.mainImage = image
        self.fullName = fullName
        self.detailUrl = detailUrl
    }
}
