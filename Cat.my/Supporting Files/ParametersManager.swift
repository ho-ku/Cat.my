//
//  ParametersManager.swift
//  Cat.my
//
//  Created by Денис Андриевский on 23.05.2020.
//  Copyright © 2020 Денис Андриевский. All rights reserved.
//

import Foundation
import CoreData

class ParametersManager {
    
    private var coreDataStack = CoreDataStack(modelName: "Cat")
    
    func save(parameters: FetchParameters) {
        let newParameters = Parameters(context: coreDataStack.managedContext)
        newParameters.hairless = parameters.hairless
        newParameters.childFriendlyMin = Int16(parameters.childFriendly.lowerBound)
        newParameters.childFriendlyMax = Int16(parameters.childFriendly.upperBound)
        newParameters.dogFriendlyMin = Int16(parameters.dogFriendly.lowerBound)
        newParameters.dogFriendlyMax = Int16(parameters.dogFriendly.upperBound)
        newParameters.hypoallergenic = parameters.hypoallergenic
        newParameters.rare = parameters.rare
        coreDataStack.saveContext()
    }
    
    func clear() {
        let fetchRequest = NSFetchRequest<Parameters>(entityName: "Parameters")
        if let result = try? coreDataStack.managedContext.fetch(fetchRequest) {
            for object in result {
                coreDataStack.managedContext.delete(object)
            }
        }
    }
    
    func fetch() -> FetchParameters? {
        let fetchRequest = NSFetchRequest<Parameters>(entityName: "Parameters")
        let results = try? coreDataStack.managedContext.fetch(fetchRequest)
        guard let res = results?.last else { return nil }
        let params = FetchParameters()
        params.childFriendly = Int(res.childFriendlyMin)...Int(res.childFriendlyMax)
        params.dogFriendly = Int(res.dogFriendlyMin)...Int(res.dogFriendlyMax)
        params.hairless = res.hairless
        params.rare = res.rare
        params.hypoallergenic = res.hypoallergenic
        return params
    }
    
}
