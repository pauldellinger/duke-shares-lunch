//
//  UIViewController+Report.swift
//  FoodPointer
//
//  Created by Paul Dellinger on 1/17/20.
//  Copyright © 2020 July Guys. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{
    func segueReport(user: User){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ReportViewController") as! ReportViewController
        controller.user = user
        let navController = UINavigationController(rootViewController: controller)
        self.navigationController?.present(navController, animated: true, completion: nil)
    }
}
