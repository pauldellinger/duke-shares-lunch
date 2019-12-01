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
        userPage.user = user
        
        let buyNav = self.viewControllers![0] as! UINavigationController
        let buyPage = buyNav.children[0] as! LocationTableViewController
        buyPage.user = user
        
        let sellNav = self.viewControllers![1] as! UINavigationController
        let sellPage = sellNav.children[0] as! MySalesViewController
        sellPage.user = user
        
        
        
        //print(self.viewControllers)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
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
