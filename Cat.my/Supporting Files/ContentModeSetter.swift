//
//  ContentModeSetter.swift
//  Cat.my
//
//  Created by Денис Андриевский on 24.05.2020.
//  Copyright © 2020 Денис Андриевский. All rights reserved.
//

import UIKit

class ContentModeSetter {

    
    class func getContentMode(for image: UIImage) -> UIView.ContentMode {
        let heightInPoints = image.size.height
        let heightInPixels = heightInPoints * image.scale
        let widthInPoints = image.size.width
        let widthInPixels = widthInPoints * image.scale
        if widthInPixels > heightInPixels {
            return .scaleAspectFit
        } else {
            return .scaleAspectFill
        }
    }
    
}
