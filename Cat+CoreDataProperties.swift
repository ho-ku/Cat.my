//
//  Cat+CoreDataProperties.swift
//  Cat.my
//
//  Created by Денис Андриевский on 24.05.2020.
//  Copyright © 2020 Денис Андриевский. All rights reserved.
//
//

import Foundation
import CoreData


extension Cat {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Cat> {
        return NSFetchRequest<Cat>(entityName: "Cat")
    }

    @NSManaged public var childFriendly: Int16
    @NSManaged public var dogFriendly: Int16
    @NSManaged public var favorite: Bool
    @NSManaged public var hair: Bool
    @NSManaged public var hypoalerg: Bool
    @NSManaged public var id: String?
    @NSManaged public var images: NSObject?
    @NSManaged public var name: String?
    @NSManaged public var origin: String?
    @NSManaged public var rare: Bool
    @NSManaged public var summary: String?
    @NSManaged public var watched: Bool

}
