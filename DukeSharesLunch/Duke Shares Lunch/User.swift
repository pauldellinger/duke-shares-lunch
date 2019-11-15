//
//  User.swift
//  Duke Shares Lunch
//
//  Created by Paul Dellinger on 11/15/19.
//  Copyright © 2019 July Guys. All rights reserved.
//

import UIKit

class User {
    
    //MARK: Properties
    var uid: Int
    var name: String
    var email: String
    var venmo: String
    var major: String?
    var dorm: String?
    
    init? (uid:Int, name:String, email:String, venmo:String){
        self.uid = uid
        self.name = name
        self.email = email
        self.venmo = venmo
    }
}


