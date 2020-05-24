//
//  WelcomeCatImageView.swift
//  Cat.my
//
//  Created by Денис Андриевский on 23.05.2020.
//  Copyright © 2020 Денис Андриевский. All rights reserved.
//

import UIKit

class WelcomeCatImageView: UIImageView {

    override init(image: UIImage?) {
        super.init(image: image)
        clipsToBounds = true
        contentMode = .scaleAspectFill
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
