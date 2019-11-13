//
//  Seller.swift
//  Duke Shares Lunch
//
//  Created by Chris Theodore on 11/13/19.
//  Copyright © 2019 July Boys. All rights reserved.
//

import UIKit

class Seller{
    
    //MARK: Properties
    
    var name: String
    var rate: Int
    var ordertime: Date
    
    
    init?(name: String, rate: Int, ordertime: Date) {
        self.name = name
        self.rate = rate
        self.ordertime = ordertime
        // Initialization should fail if there is no name or if the rating is negative.
        if name.isEmpty || (rate < 0 || rate>1 ){
            return nil
        }
    }
}


