//
//  CharacteristicsCell.swift
//  Cat.my
//
//  Created by Денис Андриевский on 24.05.2020.
//  Copyright © 2020 Денис Андриевский. All rights reserved.
//

import UIKit

class CharacteristicsCell: UITableViewCell {
    
    @IBOutlet weak var hairlessLabel: UILabel! {
        didSet {
            hairlessLabel.layer.cornerRadius = 15
            hairlessLabel.clipsToBounds = true
        }
    }
    @IBOutlet weak var hypoLabel: UILabel! {
        didSet {
            hypoLabel.layer.cornerRadius = 15
            hypoLabel.clipsToBounds = true
        }
    }
    @IBOutlet weak var rareLabel: UILabel! {
        didSet {
            rareLabel.layer.cornerRadius = 15
            rareLabel.clipsToBounds = true
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
