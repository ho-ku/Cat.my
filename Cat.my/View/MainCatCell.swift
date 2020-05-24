//
//  MainCatCell.swift
//  Cat.my
//
//  Created by Денис Андриевский on 24.05.2020.
//  Copyright © 2020 Денис Андриевский. All rights reserved.
//

import UIKit

class MainCatCell: UITableViewCell {
    
    @IBOutlet weak var catName: UILabel!
    @IBOutlet weak var origin: UILabel!
    @IBOutlet weak var catImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
