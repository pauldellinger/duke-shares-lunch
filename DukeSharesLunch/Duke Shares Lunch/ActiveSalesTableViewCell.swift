//
//  ActiveSalesTableViewCell.swift
//  Duke Shares Lunch
//
//  Created by Paul Dellinger on 11/29/19.
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
        // add shadow on cell
        backgroundColor = .lightText // very important
        layer.masksToBounds = false
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 10
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowColor = UIColor.black.cgColor

        // add corner radius on `contentView`
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 20
        // Initialization code
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let margins = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        contentView.frame = contentView.frame.inset(by: margins)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}


