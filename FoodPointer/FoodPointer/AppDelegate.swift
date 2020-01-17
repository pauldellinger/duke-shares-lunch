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


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{

    var window: UIWindow?
    let notificationCenter = UNUserNotificationCenter.current()
    //var handle: AuthStateDidChangeListenerHandle?
    var user: User?
    var deviceToken: String?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        let notificationOption = launchOptions?[.remoteNotification]
        // 1
        if let notification = notificationOption as? [String: AnyObject],
            let aps = notification["aps"] as? [String: AnyObject] {
        }
        application.applicationIconBadgeNumber = 0

        if #available(iOS 13, *) {
            // do only pure app launch stuff, not interface stuff
            
        } else {
            self.window = UIWindow(frame: UIScreen.main.bounds)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "LoginPage")
            
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
        }
        return true
    }
//    func signIn(){
//        self.handle = Auth.auth().addStateDidChangeListener { auth, signedInUser in
//            if let signedInUser = signedInUser {
//                print(signedInUser.email)
//                signedInUser.getIDTokenForcingRefresh(true) { idToken, error in
//                    if let error = error {
//                        print(error)
//                        return;
//                    }
//                    print(idToken)
//                    // let user = User(email: signedInUser.email ?? "", password: "")
//                    self.user?.token = idToken
//                    self.user?.uid = signedInUser.uid
//                    print("got here in app delegate")
//                    self.registerForPushNotifications()
//                    //print(user?.email, user?.password, user?.token, user?.uid)
//                }
//            } else {
//                let authUI = FUIAuth.defaultAuthUI()
//                // You need to adopt a FUIAuthDelegate protocol to receive callback
//                authUI?.delegate = self as FUIAuthDelegate
//                let providers: [FUIAuthProvider] = [
//                    FUIGoogleAuth(),
//                    FUIEmailAuth()
//                ]
//                authUI?.providers = providers
//                let authViewController = authUI?.authViewController()
//                let vc = UIViewController()
//                self.window?.rootViewController = vc
//                vc.present(authViewController!, animated: true)
//            }
//        }
//    }
    func uploadDeviceToken(deviceToken: String) {
        print("trying to upload device token")
        
        self.user?.registerDevice(deviceToken: deviceToken, completion: { user, error in
            if let error = error{
                print("devicetoken error: ", error)
            }else{
                print("Device Token Sucessfully uploaded")
            }
        })
    }
    
//    func registerForPushNotifications() {
//        UNUserNotificationCenter.current()
//            .requestAuthorization(options: [.alert, .sound, .badge]) {
//                [weak self] granted, error in
//
//                print("Permission granted: \(granted)")
//                guard granted else { return }
//                DispatchQueue.main.async {
//                    UIApplication.shared.registerForRemoteNotifications()
//                }
//                self?.getNotificationSettings()
//        }
//    }
    
    func getNotificationSettings() {
      UNUserNotificationCenter.current().getNotificationSettings { settings in
        print("Notification settings: \(settings)")
      }
    }
    
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        self.deviceToken = token
        uploadDeviceToken(deviceToken: token)
    }

    func application(
      _ application: UIApplication,
      didFailToRegisterForRemoteNotificationsWithError error: Error) {
      print("Failed to register: \(error)")
    }
    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable: Any],
        fetchCompletionHandler completionHandler:
        @escaping (UIBackgroundFetchResult) -> Void
    ) {
        application.applicationIconBadgeNumber = 0
        guard let aps = userInfo["aps"] as? [String: AnyObject] else {
            completionHandler(.failed)
            return
        }
        let message = Notification.init(name: .didReceivePush)
        NotificationCenter.default.post(message)
        
        /*
        let currentVC = UIApplication.shared.keyWindow?.rootViewController as! UINavigationController
        
        print(currentVC)
        print(currentVC.topViewController)
        let tabBar = currentVC.topViewController as! TabController
        tabBar.refreshAll()
        */
        
    }
    
}

extension Notification.Name {

    static let didReceivePush = Notification.Name("DidReceivePush")

}

