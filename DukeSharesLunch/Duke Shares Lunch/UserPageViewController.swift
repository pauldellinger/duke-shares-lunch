//
//  UserPageViewController.swift
//  Duke Shares Lunch
//
//  Created by Paul Dellinger on 11/21/19.
//  Copyright © 2019 July Guys. All rights reserved.
//

import UIKit
import Foundation

class UserPageViewController: UIViewController, UITextFieldDelegate {
    
    var user = User(email:"", password:"")
    
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
                self.user = User.init(email: email, password: pass)
                // print(user?.email, user?.password)
                user?.login(viewController: self)
                //sleep(2)
                // print(user?.token)
                
            }
            else{
                showError()
            }
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        let token = defaults.string(forKey: "token")
        print(token)
        
        if !(token?.isEmpty ?? true){
            let defaults = UserDefaults.standard
            let email = defaults.string(forKey: "email")
            let password = defaults.string(forKey: "password")
            let token = defaults.string(forKey: "token")
            self.user = User(email: email!, password: password!)
            self.user?.token = token
            print(self.user?.email, self.user?.password, user?.token)
            self.performSegue(withIdentifier: "loginSegue", sender: self)
            
        }
        self.emailInput.delegate = self
        self.passwordInput.delegate = self
        emailInput.becomeFirstResponder()
        emailInput.placeholder = "email"
        passwordInput.placeholder = "password"
        let tap = UITapGestureRecognizer(target:self.view, action: #selector(self.view.endEditing))
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    func tokenUpdated(user:User){
           self.performSegue(withIdentifier: "loginSegue", sender: self)
           
       }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == emailInput) {
           emailInput.text = ""
        }
        else if (textField == passwordInput) {
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
        guard let nextController = segue.destination as? TabController
            else {
                return
        }
        nextController.user = user
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

}
