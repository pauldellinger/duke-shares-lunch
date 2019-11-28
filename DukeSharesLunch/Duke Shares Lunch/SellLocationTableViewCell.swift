//
//  SellLocationTableViewCell.swift
//  Duke Shares Lunch
//
//  Created by Chris Theodore on 11/27/19.
//  Copyright © 2019 July Guys. All rights reserved.
//

import UIKit

class SellLocationTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    
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
