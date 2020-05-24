//
//  Cat.swift
//  Cat.my
//
//  Created by Денис Андриевский on 23.05.2020.
//  Copyright © 2020 Денис Андриевский. All rights reserved.
//

import Foundation

struct CatElement: Codable {
    var childFriendly: Int
    var dogFriendly: Int
    var hairless, hypoallergenic: Int
    var id: String
    var name: String
    var origin: String
    var rare: Int
    var catDescription: String

    enum CodingKeys: String, CodingKey {
        case childFriendly = "child_friendly"
        case catDescription = "description"
        case dogFriendly = "dog_friendly"
        case hairless
        case hypoallergenic, id
        case name, origin, rare
    }
}

typealias Cats = [CatElement]
