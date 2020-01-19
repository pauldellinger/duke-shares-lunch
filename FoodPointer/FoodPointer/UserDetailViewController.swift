//
//  UserDetailViewController.swift
//  Duke Shares Lunch
//
//  Created by Paul Dellinger on 11/21/19.
//  Copyright © 2019 July Guys. All rights reserved.
//

import UIKit
import FirebaseUI

class UserDetailViewController: UIViewController {


    @IBAction func reportAction(_ sender: Any) {
        if let user = self.user{
            self.segueReport(user: user)
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var venmoLabel: UILabel!
    @IBOutlet weak var dormLabel: UILabel!
    @IBOutlet weak var majorLabel: UILabel!
 
    
    @IBAction func logoutAction(_ sender: Any) {
        let authUI = FUIAuth.defaultAuthUI()
        
        do {try authUI?.signOut() }catch { print("no user to sign out")}
        self.user?.removeDeviceTokens(completion: { user, error in
            if let error = error{
                print("removedevicetoken error: ", error)
            }else{
                print("Device Tokens Sucessfully removed")
            }
        })
        tabBarController?.navigationController?.popToRootViewController(animated: true)
    }
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = user?.name
        venmoLabel.text = user?.venmo
        dormLabel.text = user?.dorm
        majorLabel.text = user?.major
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if let detailViewController = segue.destination as? ReportViewController{
            detailViewController.user = self.user
        }
    }
    

}
