//
//  FetchParameters.swift
//  Cat.my
//
//  Created by Денис Андриевский on 23.05.2020.
//  Copyright © 2020 Денис Андриевский. All rights reserved.
//

import Foundation

class FetchParameters {
    
    var rare: Bool = false
    var hairless: Bool = false
    var hypoallergenic: Bool = false
    var dogFriendly: ClosedRange<Int> = 1...5
    var childFriendly: ClosedRange<Int> = 1...5
    
}
