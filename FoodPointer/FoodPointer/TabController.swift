//
//  TabController.swift
//  Duke Shares Lunch
//
//  Created by Paul Dellinger on 11/23/19.
//  Copyright © 2019 July Guys. All rights reserved.
//

import UIKit

class TabController: UITabBarController{
    var user: User?
    override func viewDidLoad() {
        super.viewDidLoad()
        // print(user?.token)
        let application = UIApplication.shared
        
        // every time we load this controller, we update the device token
        // This means even though we delete all tokens on logout,
        // as soon as a user comes back to the app (on any phone)
        // they'll get push notifications again
        registerPushNotifications(application)
        
        user?.getInfo(viewController:self)
        
    }
    func handleInfo(){
        let userPage = self.viewControllers![2] as! UserDetailViewController
        userPage.user = user
        
        let buyNav = self.viewControllers![0] as! UINavigationController
        let buyPage = buyNav.children[0] as! LocationTableViewController
        buyPage.user = user
        
        let sellNav = self.viewControllers![1] as! UINavigationController
        let sellPage = sellNav.children[0] as! MySalesViewController
        sellPage.user = user
        let _ = sellPage.view
    }
        
        
        
        
        //print(self.viewControllers)
        // Do any additional setup after loading the view.
    
    
    func registerPushNotifications(_ application: UIApplication){
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) {
            (didAllow, error) in
            if !didAllow {
                print("User has declined notifications")
                //TODO: mark token as inactive in database
            }
            DispatchQueue.main.async {
                guard let appControls = application.delegate as? AppDelegate else{
                    print("problem setting as AppDelegate")
                    return
                }
                appControls.user = self.user
                application.registerForRemoteNotifications()
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func refreshAll(){
        print("Gonna refresh now")
        let sellNav = self.viewControllers![1] as! UINavigationController
        let buyNav = self.viewControllers![0] as! UINavigationController
        let viewController = UIApplication.shared.windows.first!.rootViewController
        let sellController = sellNav.visibleViewController
        let buyController = buyNav.visibleViewController
        print(buyController)
        if let sellController = sellController as? UITableViewController{
            sellController.refreshControl?.beginRefreshing()
        }
        if let buyController = sellController as? UITableViewController{
            buyController.refreshControl?.beginRefreshing()
        }
    }
    
    
}


