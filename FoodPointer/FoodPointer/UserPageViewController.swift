//
//  UserPageViewController.swift
//  Duke Shares Lunch
//
//  Created by Paul Dellinger on 11/21/19.
//  Copyright © 2019 July Guys. All rights reserved.
//

import UIKit
import Foundation

import Firebase
import FirebaseUI
import FirebaseAuth


class UserPageViewController: UIViewController, UITextFieldDelegate, FUIAuthDelegate{
    
    
    var authUI: FUIAuth?
    var user: User?
    
    
    /** @var handle
        @brief The handler for the auth state listener, to allow cancelling later.
     */
    var handle: AuthStateDidChangeListenerHandle?

    @IBAction func checkVerifyAction(_ sender: Any) {
        guard let currentUser = Auth.auth().currentUser else {
            print("no current user")
            return
            
        }
        print(currentUser.email)
        Auth.auth().currentUser?.reload(completion: { (error) in
            if let error = error{
                print(error)
            }
            print("email verified: ",currentUser.isEmailVerified)
            self.tryLogin()
        })
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("view loaded")
        self.tryLogin()
    }
        
        
        /*
        if !(email?.isEmpty ?? true){ //if email has already been set
            let defaults = UserDefaults.standard
            let email = defaults.string(forKey: "email")
            let password = defaults.string(forKey: "password")
            //let token = defaults.string(forKey: "token")
            self.user = User(email: email!, password: password!)
            
            //login with saved email and password
            
            // self.user?.login(viewController: self)
            
        } else{
        self.emailInput.delegate = self
        self.passwordInput.delegate = self
        emailInput.becomeFirstResponder()
        emailInput.placeholder = "email"
        passwordInput.placeholder = "password"
        
        //get rid of keyboard on tap
        let tap = UITapGestureRecognizer(target:self.view, action: #selector(self.view.endEditing))
        view.addGestureRecognizer(tap)
        }
    */
    private func tryLogin(){
        print("trying login")
        self.handle = Auth.auth().addStateDidChangeListener { auth, signedInUser in
            guard let signedInUser = signedInUser else {
                print("no signed in user")
                self.authUI = FUIAuth.defaultAuthUI()
                self.authUI?.delegate = self as FUIAuthDelegate
                let providers: [FUIAuthProvider] = [
                    FUIGoogleAuth(),
                    FUIEmailAuth()
                ]
                self.authUI?.providers = providers
                if let authVC = FUIAuth.defaultAuthUI()?.authViewController() {
                    self.present(authVC, animated: true, completion: nil)
                }
                return }
            
            if signedInUser.isEmailVerified{
                print(signedInUser.email)
                
                signedInUser.getIDTokenForcingRefresh(true) { idToken, error in
                    if let error = error {
                        print(error)
                        return;
                    }
                    print(idToken)
                    self.user = User(email: signedInUser.email ?? "", password: "")
                    self.user?.token = idToken
                    self.user?.uid = signedInUser.uid
                    self.user?.name = signedInUser.displayName
                    print("got here")
                    print(self.user?.email, self.user?.password, self.user?.token, self.user?.uid, self.user?.name)
                    self.user?.getInfo2(completion:{user, error in
                        if let error = error{
                            print("get info error: ", error)
                        }
                        print("user's venmo: ", self.user?.venmo)
                        if self.user?.venmo?.isEmpty ?? true{
                            self.user?.createRole(uid: signedInUser.uid, completion: {user, error in
                                if let error = error{
                                    print(error)
                                }
                                print("user role creation successful")
                                DispatchQueue.main.async{
                                    //let topVC = topMostController()
                                    self.performSegue(withIdentifier: "newUserSegue", sender: self)
                                }
                            })
                        } else{
                            DispatchQueue.main.async{
                                self.performSegue(withIdentifier: "loginSegue", sender: self)
                            }
                        }
                    })
                }
            } else{
                print("unverified email")
                let alert = UIAlertController(title: "Unverified Email", message: "Email verification sent, please verify before continuing", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    switch action.style{
                    case .default:
                        print("default")
                        
                    case .cancel:
                        print("cancel")
                        
                    case .destructive:
                        print("destructive")
                        
                        
                    }}))
                alert.addAction(UIAlertAction(title: "Resend Verifcation Email", style: .default, handler: { action in
                    if !signedInUser.isEmailVerified{
                        print("email not verifed, resending verification email")
                        signedInUser.sendEmailVerification { (error) in
                            if let error = error{
                                print(error)
                            }
                        }
                    }
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

    
    override func viewWillAppear(_ animated: Bool) {
        print("view will appear")
        //tryLogin()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        //Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    
    
    
    private func credentialValidate(email:String, password:String) ->Bool{
        let range = NSRange(location: 0, length: email.utf16.count)
        let regex = try! NSRegularExpression(pattern: "^[-!#$%&'*+/0-9=?A-Z^_a-z{|}~](\\.?[-!#$%&'*+/0-9=?A-Z^_a-z{|}~])*@[a-zA-Z](-?[a-zA-Z0-9])*(\\.[a-zA-Z](-?[a-zA-Z0-9])*)+$")
        if regex.firstMatch(in: email, options: [], range: range) == nil { return false }
        
        
        let rangePass = NSRange(location: 0, length: password.utf16.count)
        let regexPass = try! NSRegularExpression(pattern:"^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[a-zA-Z-_\\d]{6,30}$")
        if regexPass.firstMatch(in: password, options: [], range: rangePass) == nil { return false }
        
        return true
    }
    
//    func showError() {
//        let animationDuration = 0.25
//
//        // Fade in the view
//        UIView.animate(withDuration: animationDuration, animations: { () -> Void in
//            self.invalidLabel.alpha = 1
//            }) { (Bool) -> Void in
//
//                // After the animation completes, fade out the view after a delay
//
//                UIView.animate(withDuration: animationDuration, delay: 5, animations: { () -> Void in
//                    self.invalidLabel.alpha = 0
//                    },
//                    completion: nil)
//        }
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let nextController = segue.destination as? TabController{
            nextController.user = self.user
        }
        if let nextController = segue.destination as? CreateProfileViewController{
            nextController.user = self.user
        }
    }
    func tokenUpdated(user:User){
        //segue to main app
        self.performSegue(withIdentifier: "loginSegue", sender: self)
        
    }
    func authUI(_ authUI: FUIAuth, didSignInWith user: FirebaseUI.User?, error: Error?) {
        print("signed in baby!!!")
        guard let user = user else {
            print(error)
            return
        }
        print("email is verified: ",user.isEmailVerified)
        if !user.isEmailVerified{
            user.sendEmailVerification { error in
                if let error = error{
                    print(error)
                    return
                }
            }
        }
        
        
    }
        
}
