//
//  PredicateFormatter.swift
//  Cat.my
//
//  Created by Денис Андриевский on 23.05.2020.
//  Copyright © 2020 Денис Андриевский. All rights reserved.
//

import Foundation

class PredicateFormatter {
    
    class func formPredicate(parameters: FetchParameters) -> NSPredicate {
        
        var predicateFormat = "%K >= %i AND %K <= %i AND %K >= %i AND %K <= %i AND %K == %i"
        var keys = ["childFriendly", "childFriendly", "dogFriendly", "dogFriendly", "watched"]
        var args = [parameters.childFriendly.lowerBound, parameters.childFriendly.upperBound, parameters.dogFriendly.lowerBound, parameters.dogFriendly.upperBound, 0]
        if parameters.hairless {
            predicateFormat += " AND %K == %i"
            args.append(1)
            keys.append("hair")
        }
        if parameters.hypoallergenic {
            predicateFormat += " AND %K == %i"
            args.append(1)
            keys.append("hypoalerg")
        }
        if parameters.rare {
            predicateFormat += " AND %K == %i"
            args.append(1)
            keys.append("rare")
        }
        var arguments = [Any]()
        for i in 0..<keys.count {
            arguments.append(keys[i])
            arguments.append(args[i])
        }
        return NSPredicate(format: predicateFormat, argumentArray: arguments)
    }
    
}
