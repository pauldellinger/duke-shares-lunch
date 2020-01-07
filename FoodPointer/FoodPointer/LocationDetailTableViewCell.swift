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
        // add shadow on cell
        backgroundColor = .clear // very important
        layer.masksToBounds = false
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 50 // this seems high but it looks good
        layer.shadowOffset = CGSize(width: 0, height: 0)
        if #available(iOS 13.0, *) {
            layer.shadowColor = UIColor.secondaryLabel.cgColor
        } else {
            // Fallback on earlier versions
            layer.shadowColor = UIColor.lightGray.cgColor
        }

        // add corner radius on `contentView`
        if #available(iOS 13.0, *) {
            contentView.backgroundColor = .quaternarySystemFill
        } else {
            contentView.backgroundColor = .white
        }
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
