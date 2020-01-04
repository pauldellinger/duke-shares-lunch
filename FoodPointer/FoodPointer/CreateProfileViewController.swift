//
//  CreateProfileViewController.swift
//  Duke Shares Lunch
//
//  Created by Paul Dellinger on 12/6/19.
//  Copyright © 2019 July Guys. All rights reserved.
//

import UIKit

class CreateProfileViewController: UIViewController {
    
    @IBOutlet weak var invalidLabel: UILabel!
    
    
    var user: User?
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var venmoField: UITextField!
    @IBOutlet weak var majorField: UITextField!
    @IBOutlet weak var dormField: UITextField!
    
    @IBAction func submitAction(_ sender: Any) {
        if validate(){
            // user = User(name: nameField.text!, email: emailField.text!, password: passwordField.text!, venmo: venmoField.text!, major: majorField.text, dorm: dormField.text)
            user?.venmo = venmoField.text
            user?.name = nameField.text
            user?.major = majorField.text
            user?.dorm = dormField.text
            
            
            user?.addUser(completion: { user, error in
                if let error = error{
                    print(error)
                    return
                }
                
                self.user = user
                if (self.user?.uid) != nil{
                    DispatchQueue.main.async{
                        self.handleSuccessfulCreate()
                    }
                } else{
                    DispatchQueue.main.async{
                        self.showError(error: error ?? "Error creating user in database")
                    }
                }
            })
        }
        else{
            showError(error: "Invalid fields\nDo you have an uppercase letter and digit in your password?")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target:self.view, action: #selector(self.view.endEditing))
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    func validate()->Bool{
        let name = nameField.text ?? ""
        //let email = emailField.text ?? ""
        //let password = passwordField.text ?? ""
        //let passwordConfirm = passwordField.text ?? ""
        let venmo = venmoField.text ?? ""
        let dorm = dormField.text ?? "No dorm"
        let major = majorField.text ?? "No Major"
        /*
        if password != passwordConfirm {
            return false
        }
        */
        
        /*
        if !regexIt(text: email, regex: try! NSRegularExpression(pattern: "^[-!#$%&'*+/0-9=?A-Z^_a-z{|}~](\\.?[-!#$%&'*+/0-9=?A-Z^_a-z{|}~])*@[a-zA-Z](-?[a-zA-Z0-9])*(\\.[a-zA-Z](-?[a-zA-Z0-9])*)+$")){
            //invalid email
            return false
        }
        if !regexIt(text: password, regex: try! NSRegularExpression(pattern:"^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[a-zA-Z-_\\d]{6,30}$")){
            //invalid password
            return false
        }
        */
        if !regexIt(text: venmo, regex: try! NSRegularExpression(pattern:"^(?=.*[a-z])[a-zA-Z-_\\d]{6,30}$")){
            //invalid venmo
            return false
        }
        
        if !regexIt(text: name, regex:  try! NSRegularExpression(pattern:"^(?=.*[a-z])[ a-zA-Z-_\\d]{5,50}$")){
            //invalid name
            return false
        }
        if !dorm.isEmpty{
            if !regexIt(text: dorm, regex:  try! NSRegularExpression(pattern:"^(?=.*[a-z])[ a-zA-Z-_\\d]{0,50}$")){
                //invalid dorm
                return false
            }
        }
        if !major.isEmpty{
            if !regexIt(text: major, regex:  try! NSRegularExpression(pattern:"^(?=.*[a-z])[ a-zA-Z-_\\d]{0,50}$")){
                //invalid name
                return false
            }
        }
        // TODO: verify venmo account exists
        
        return true
    }
    
    func regexIt(text: String, regex: NSRegularExpression)-> Bool{
        //returns true if the string matches the regex
        let range = NSRange(location: 0, length: text.utf16.count)
        if regex.firstMatch(in: text, options: [], range: range) == nil {
            return false
        }
        return true
        
    }
    func handleSuccessfulCreate(){
        //print(user?.token, "Token create page received")
        performSegue(withIdentifier: "createProfileSegue", sender: self)
    }
    func handleDatabaseCreateFail(){
        showError(error: "Couldn't create user in database")
    }
        
    func showError(error: String) {
        let animationDuration = 0.25

        // Fade in the view
        self.invalidLabel.text = error
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        guard let nextController = segue.destination as? TabController
            else {
                return
        }
        nextController.user = user
    }

}