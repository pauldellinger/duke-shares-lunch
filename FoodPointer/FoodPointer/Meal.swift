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
    init?(json:[String:Any]){
        guard let mealName = json["name"] as? String else{
            print("bad name in meal")
            return nil
        }
        guard let mealPrice = json["price"] as? Double else{
            print("bad price in meal")
            return nil
        }
        self.name = mealName
        self.price = mealPrice
    }
}
