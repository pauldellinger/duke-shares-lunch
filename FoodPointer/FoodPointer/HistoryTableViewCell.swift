//
//  HistoryTableViewCell.swift
//  FoodPointer
//
//  Created by Paul Dellinger on 1/7/20.
//  Copyright © 2020 July Guys. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var buyerLabel: UILabel!
    @IBOutlet var sellerLabel: UILabel!
    @IBOutlet var approveLabel: UILabel!
    @IBOutlet var paidLabel: UILabel!
    @IBOutlet var itemsLabel: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    var hid: Int?

}
