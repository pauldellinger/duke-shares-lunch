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

@objc(UserPageViewController)
class UserPageViewController: UIViewController, UITextFieldDelegate, FUIAuthDelegate{
    
    var user: User?
    
    /** @var handle
        @brief The handler for the auth state listener, to allow cancelling later.
     */
    var handle: AuthStateDidChangeListenerHandle?

    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var invalidLabel: UILabel!
    
    @IBAction func loginAction(_ sender: Any) {
        print("logging in!")
        if !(emailInput.text?.isEmpty ?? true) && !(passwordInput.text?.isEmpty ?? true) {
            let email = emailInput.text!
            let pass = passwordInput.text!
            if credentialValidate(email: email, password: pass){
                print("valid!")
                Auth.auth().signIn(withEmail: email, password: pass) { [weak self] authResult, error in
                  guard let strongSelf = self else { return }
                  // ...
                }
                self.user?.email = email
                self.user?.password = pass
                self.user?.login(viewController: self)
                
            }
            else{
                showError()
            }
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        let email = defaults.string(forKey: "email")
        print(email)
        
        //FirebaseApp.configure()
        
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.handle = Auth.auth().addStateDidChangeListener { auth, signedInUser in
            if let signedInUser = signedInUser {
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
                    print("got here")
                    print(self.user?.email, self.user?.password, self.user?.token, self.user?.uid)
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
                                    self.performSegue(withIdentifier: "createProfileSegue", sender: self)
                                }
                            })
                        } else{
                            DispatchQueue.main.async{
                                self.performSegue(withIdentifier: "loginSegue", sender: self)
                            }
                        }
                        })
                    }
                } else {
                let authUI = FUIAuth.defaultAuthUI()
                // You need to adopt a FUIAuthDelegate protocol to receive callback
                authUI?.delegate = self as FUIAuthDelegate
                let providers: [FUIAuthProvider] = [
                    FUIGoogleAuth(),
                    FUIEmailAuth()
                ]
                authUI?.providers = providers
                let authViewController = authUI?.authViewController()
                self.present(authViewController!, animated: true)
            }
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == passwordInput) {
           passwordInput.text = ""
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailInput {
            textField.resignFirstResponder()
            passwordInput.becomeFirstResponder()
        } else if textField == passwordInput {
            loginAction(self)
        }
        return false
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
    
    func showError() {
        let animationDuration = 0.25

        // Fade in the view
        UIView.animate(withDuration: animationDuration, animations: { () -> Void in
            self.invalidLabel.alpha = 1
            }) { (Bool) -> Void in

                // After the animation completes, fade out the view after a delay

                UIView.animate(withDuration: animationDuration, delay: 5, animations: { () -> Void in
                    self.invalidLabel.alpha = 0
                    },
                    completion: nil)
        }
    }

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
    func authUI(_ authUI: FUIAuth, didSignInWith firebaseUser: FirebaseUI.User?, additionalInfo: AdditionalUserInfo?, error: Error?) {
      // handle user and error as necessary
        print("Signed in with Firebase!!!")
        if let error = error{
            print(error)
            return
        }
        
        firebaseUser?.getIDToken(completion: {idToken, error in
            if let error = error {
                print(error)
                return
            }
            print(firebaseUser?.email)
            self.user?.token = idToken
            self.user?.email = firebaseUser?.email
            self.user?.uid = firebaseUser?.uid
            if (additionalInfo?.isNewUser ?? false){
                self.user?.createRole(uid: firebaseUser?.uid ?? "", completion: {user, error in
                    if let error = error{
                        print(error)
                    }
                    print("user role creation successful")
                    self.performSegue(withIdentifier: "createProfileSegue", sender: self)
                })
            } else{
                self.user?.getInfo2(completion:{user, error in
                    if let error = error{
                        print(error)
                    }
                    print(user)
                })
                
            self.performSegue(withIdentifier: "loginSegue", sender: self)
            }
        })
        
    }
}
