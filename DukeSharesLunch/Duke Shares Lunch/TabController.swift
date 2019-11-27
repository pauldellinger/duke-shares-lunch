//
//  TabController.swift
//  Duke Shares Lunch
//
//  Created by Chris Theodore on 11/23/19.
//  Copyright © 2019 July Guys. All rights reserved.
//

import UIKit

class TabController: UITabBarController {
    var user: User?
    override func viewDidLoad() {
        super.viewDidLoad()
        // print(user?.token)
        user?.getInfo()
        let userPage = self.viewControllers![2] as! UserDetailViewController
        let sellPage = self.viewControllers![0] as! LocationTableViewController
        
        userPage.user = user
        sellPage.user = user

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let nextController = segue.destination as? UserDetailViewController
            else {
                return
        }
        nextController.user = user
    }
 */
    

}
