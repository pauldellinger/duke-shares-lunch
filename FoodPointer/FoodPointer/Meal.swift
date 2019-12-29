//
//  Meal.swift
//  Duke Shares Lunch
//
//  Created by Paul Dellinger on 11/27/19.
//  Copyright © 2019 July Guys. All rights reserved.
//

import UIKit

class Meal {
    var name: String
    var price: Double
    
    init?(name: String, price: Double) {
        self.name = name
        self.price = price
        // Initialization should fail if there is no name or if the rating is negative.
        if name.isEmpty || price < 0 {
            return nil
        }
    }
}
