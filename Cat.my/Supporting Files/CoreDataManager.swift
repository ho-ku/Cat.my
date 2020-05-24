//
//  CoreDataManager.swift
//  Cat.my
//
//  Created by Денис Андриевский on 24.05.2020.
//  Copyright © 2020 Денис Андриевский. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    
    private let coreDataStack = CoreDataStack(modelName: "Cat")
    
    func refresh() {
        let fetchRequest = NSFetchRequest<Cat>(entityName: "Cat")
        let results = try? coreDataStack.managedContext.fetch(fetchRequest)
        guard let res = results else { return }
        for cat in res {
            cat.watched = false
        }
        coreDataStack.saveContext()
    }
    
    func fetchFavorites(stack: CoreDataStack) -> [Cat] {
        let fetchRequest = NSFetchRequest<Cat>(entityName: "Cat")
        fetchRequest.predicate = NSPredicate(format: "%K == %i", "favorite", 1)
        let results = try? stack.managedContext.fetch(fetchRequest)
        guard let res = results else { return [] }
        return res
    }
    
}
