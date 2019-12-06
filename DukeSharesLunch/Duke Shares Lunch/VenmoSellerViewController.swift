//
//  VenmoSellerViewController.swift
//  Duke Shares Lunch
//
//  Created by Chris Theodore on 12/1/19.
//  Copyright © 2019 July Guys. All rights reserved.
//

import UIKit

class VenmoSellerViewController: UIViewController {
    var user: User?
    var seller: Seller?
    var cost: Double?
    
    @IBAction func goVenmoAction(_ sender: Any) {
        let venmoHooks = "venmo://paycharge?txn=pay&recipients=\(seller!.sellerVenmo)&amount=\(cost!)&note=DukeSharesLunch"
        print(venmoHooks)
        let venmoUrl = URL(string: venmoHooks)
        if UIApplication.shared.canOpenURL(venmoUrl!){
            UIApplication.shared.open(venmoUrl!)
            
        } else {
            //redirect to safari because the user doesn't have Instagram
            print("Venmo not installed")
        }
    }
    
    @IBOutlet weak var instructionLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        instructionLabel.text = "Venmo \(seller!.sellerName) \n \(String(format: "%.2f", cost!))"
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
