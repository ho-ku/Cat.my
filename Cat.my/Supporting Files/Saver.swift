//
//  Saver.swift
//  Cat.my
//
//  Created by Денис Андриевский on 23.05.2020.
//  Copyright © 2020 Денис Андриевский. All rights reserved.
//

import Foundation

// MARK: - Saving to CoreData
class Saver {
    
    class func save(cats: Cats, urls: [[String]]) {
        let coreDataStack = CoreDataStack(modelName: "Cat")
        for (index, cat) in cats.enumerated() {
            let newCat = Cat(context: coreDataStack.managedContext)
            newCat.childFriendly = Int16(cat.childFriendly)
            newCat.dogFriendly = Int16(cat.dogFriendly)
            newCat.hair = cat.hairless == 1
            newCat.hypoalerg = cat.hypoallergenic == 1
            newCat.id = cat.id
            newCat.name = cat.name
            newCat.origin = cat.origin
            newCat.rare = cat.rare == 1
            newCat.summary = cat.catDescription
            newCat.images = urls[index] as NSObject
            coreDataStack.saveContext()
        }
    }
    
}
