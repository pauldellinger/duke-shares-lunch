//
//  ActiveSalesTableViewCell.swift
//  Duke Shares Lunch
//
//  Created by Chris Theodore on 11/29/19.
//  Copyright © 2019 July Guys. All rights reserved.
//

import UIKit

class ActiveSalesTableViewCell: UITableViewCell {
    
    
    
    @IBOutlet weak var notifyCircle: UIButton!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var buyerCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
