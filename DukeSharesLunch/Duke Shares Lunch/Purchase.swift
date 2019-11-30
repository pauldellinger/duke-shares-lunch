//
//  Purchase.swift
//  Duke Shares Lunch
//
//  Created by Chris Theodore on 11/29/19.
//  Copyright © 2019 July Guys. All rights reserved.
//

import UIKit

class Purchase {
    
    var pid: Int
    var seller: Seller
    var buyer: User
    var approve: Bool
    var paid: Bool
    var description: String
    
    init?(pid: Int, seller: Seller, buyer: User, approve: Bool, paid: Bool, description: String) {
        self.pid = pid
        self.seller = seller
        self.buyer = buyer
        self.approve = approve
        self.paid = paid
        self.description = description

    }
}
