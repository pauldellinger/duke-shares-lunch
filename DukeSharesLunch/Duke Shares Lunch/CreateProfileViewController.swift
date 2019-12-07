//
//  CreateProfileViewController.swift
//  Duke Shares Lunch
//
//  Created by Chris Theodore on 12/6/19.
//  Copyright © 2019 July Guys. All rights reserved.
//

import UIKit

class CreateProfileViewController: UIViewController {
    
    var user: User?
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordConfirmField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var venmoField: UITextField!
    @IBOutlet weak var majorField: UITextField!
    @IBOutlet weak var dormField: UITextField!
    
    @IBAction func submitAction(_ sender: Any) {
        if validate(){
            if let user = User(name: nameField.text!, email: emailField.text!, password: passwordField.text!, venmo: venmoField.text!, major: majorField.text, dorm: dormField.text){
                user.createUser(viewController: self)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func validate()->Bool{
        return true
    }
    func handleSuccessfulCreate(){
        print("segue here")
        performSegue(withIdentifier: "createProfileSegue", sender: self)
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
