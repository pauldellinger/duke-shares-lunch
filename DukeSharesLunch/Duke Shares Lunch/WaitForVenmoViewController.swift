//
//  WaitForVenmoViewController.swift
//  Duke Shares Lunch
//
//  Created by Chris Theodore on 11/30/19.
//  Copyright © 2019 July Guys. All rights reserved.
//

import UIKit

class WaitForVenmoViewController: UIViewController {

    @IBOutlet weak var contentLabel: UILabel!
    @IBAction func venmoCompleteAction(_ sender: Any) {
        
        purchase?.complete(user:user!, viewController:self)
    }
    @IBAction func cancelOrderAction(_ sender: Any) {
        purchase?.decline(user: user!, viewController: self)
    }
    
    var user: User?
    var purchase: Purchase?
    override func viewDidLoad() {
        super.viewDidLoad()
        contentLabel.text = "Did \(purchase!.buyer.name!) (\(purchase!.buyer.venmo!)) venmo you?"
        // Do any additional setup after loading the view.
    }
    func handleComplete(){
        performSegue(withIdentifier: "buyFoodSegue", sender: self)
    }
    func handleDecline(){
        navigationController?.popToRootViewController(animated: true)
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let nextController = segue.destination as? BuyFoodViewController{
            nextController.user = user
            nextController.purchase = purchase
        }
    }


}
