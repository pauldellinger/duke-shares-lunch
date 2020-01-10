//
//  VenmoSellerViewController.swift
//  Duke Shares Lunch
//
//  Created by Paul Dellinger on 12/1/19.
//  Copyright © 2019 July Guys. All rights reserved.
//

import UIKit

class VenmoSellerViewController: UIViewController {
    var user: User?
    var seller: Seller?
    var cost: Double?
    
    @IBAction func reportAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ReportViewController") as! ReportViewController
        controller.user = self.user
        self.present(controller, animated: true, completion: nil)
    }
    @IBAction func goVenmoAction(_ sender: Any) {
        tabBarController?.tabBar.isHidden = false
        let venmoHooks = "venmo://paycharge?txn=pay&recipients=\(seller!.sellerVenmo)&amount=\(cost!)&note=FoodPointer"
        print(venmoHooks)
        let venmoUrl = URL(string: venmoHooks)
        if UIApplication.shared.canOpenURL(venmoUrl!){
            UIApplication.shared.open(venmoUrl!)
            
        } else {
            //redirect to safari because the user doesn't have Venmo
            print("Venmo not installed")
            let alert = UIAlertController(title: "Venmo Not Installed", message: "Please Intstall Venmo", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                switch action.style{
                case .default:
                    print("default")
                    
                case .cancel:
                    print("cancel")
                    
                case .destructive:
                    print("destructive")
                    
                    
                }}))
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    @IBOutlet weak var instructionLabel: UILabel!
    override func viewDidLoad(){
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        instructionLabel.text = "Venmo \(seller!.sellerName) \n $\(String(format: "%.2f", cost!))"
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
