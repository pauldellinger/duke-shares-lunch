//
//  UserDetailViewController.swift
//  Duke Shares Lunch
//
//  Created by Paul Dellinger on 11/21/19.
//  Copyright © 2019 July Guys. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {


  
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var venmoLabel: UILabel!
    @IBOutlet weak var dormLabel: UILabel!
    @IBOutlet weak var majorLabel: UILabel!
 
    
    @IBAction func logoutAction(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.set("", forKey: "email")
        defaults.set("", forKey: "password")
        defaults.set("", forKey: "token")
        tabBarController?.navigationController?.popToRootViewController(animated: true)
    }
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = user?.name
        venmoLabel.text = user?.venmo
        dormLabel.text = user?.dorm
        majorLabel.text = user?.major
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
