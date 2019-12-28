//
//  LocationDetailTableViewCell.swift
//  Duke Shares Lunch
//
//  Created by Paul Dellinger on 11/13/19.
//  Copyright © 2019 July Guys. All rights reserved.
//

import UIKit

class LocationDetailTableViewCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var rate: UILabel!
    @IBOutlet weak var ordertime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
