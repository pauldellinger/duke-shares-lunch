//
//  MealSelectorTableViewCell.swift
//  Duke Shares Lunch
//
//  Created by Paul Dellinger on 11/24/19.
//  Copyright © 2019 July Guys. All rights reserved.
//

import UIKit

class MealSelectorTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        self.accessoryType = selected ? .checkmark : .none
    }

}
