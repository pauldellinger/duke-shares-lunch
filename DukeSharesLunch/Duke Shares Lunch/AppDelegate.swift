//
//  AppDelegate.swift
//  Duke Shares Lunch
//
//  Created by Paul Dellinger on 11/12/19.
//  Copyright © 2019 July Guys. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase
import FirebaseUI


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let notificationCenter = UNUserNotificationCenter.current()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //FirebaseApp.configure()
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

