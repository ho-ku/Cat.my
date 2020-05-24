//
//  Parameters+CoreDataProperties.swift
//  Cat.my
//
//  Created by Денис Андриевский on 23.05.2020.
//  Copyright © 2020 Денис Андриевский. All rights reserved.
//
//

import Foundation
import CoreData


extension Parameters {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Parameters> {
        return NSFetchRequest<Parameters>(entityName: "Parameters")
    }

    @NSManaged public var rare: Bool
    @NSManaged public var hairless: Bool
    @NSManaged public var hypoallergenic: Bool
    @NSManaged public var dogFriendlyMax: Int16
    @NSManaged public var childFriendlyMax: Int16
    @NSManaged public var childFriendlyMin: Int16
    @NSManaged public var dogFriendlyMin: Int16

}
