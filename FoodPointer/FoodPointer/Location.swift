//
//  Location.swift
//  Duke Shares Lunch
//
//  Created by Paul Dellinger on 11/12/19.
//  Copyright © 2019 July Guys. All rights reserved.
//

import UIKit

class Location {
    
    //MARK: Properties
    
    var name: String
    var count: Int
    
    
    //MARK: Initialization
    init?(name: String, count: Int) {
        self.name = name
        self.count = count
        // Initialization should fail if there is no name or if the rating is negative.
        if name.isEmpty || count < 0 {
            return nil
        }
    }

}


 
