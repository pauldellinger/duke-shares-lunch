//
//  AppDelegate.swift
//  Duke Shares Lunch
//
//  Created by Chris Theodore on 11/12/19.
//  Copyright © 2019 July Boys. All rights reserved.
//

import UIKit
import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {


    let notificationCenter = UNUserNotificationCenter.current()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        notificationCenter.requestAuthorization(options: options) {
            (didAllow, error) in
            if !didAllow {
                print("User has declined notifications")
            }
        }
        let defaults = UserDefaults.standard
        let email = ["email" : ""]
        defaults.register(defaults: email)
        let password = ["password" : ""]
        defaults.register(defaults: password)
        let token = ["token" : ""]
        defaults.register(defaults: token)
        return true
    }


}

