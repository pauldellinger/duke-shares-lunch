//
//  PurchaseApprovalViewController.swift
//  Duke Shares Lunch
//
//  Created by Chris Theodore on 11/30/19.
//  Copyright © 2019 July Guys. All rights reserved.
//

import UIKit

class PurchaseApprovalViewController: UIViewController {
    
    
    var user: User?
    var purchase: Purchase?
    
    @IBOutlet weak var buyerNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var foodPointCostLabel: UILabel!
    @IBOutlet weak var realMoneyLabel: UILabel!
    @IBAction func declineAction(_ sender: Any) {
        purchase?.decline(user:user!, viewController: self)
    }
    
    @IBAction func approveAction(_ sender: Any) {
        purchase?.approve(user:user!, viewController: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let description = purchase?.description.components(separatedBy: ":"){
            print(description)
            if let buyerName = purchase?.buyer.name{
                buyerNameLabel.text = "\(buyerName) would like:"
            }
            descriptionLabel.text = ""
            let meals = description[0].components(separatedBy: "#")
            for item in meals{
                descriptionLabel.text = descriptionLabel.text! + "\n\(item)"
            }
            descriptionLabel.text = (descriptionLabel!.text ?? "") + "\n"+"Notes:\(description.last!)"
            foodPointCostLabel.text = String(format: "%.2f", purchase!.price * (1.0/(purchase?.seller.rate)!))
            realMoneyLabel.text = String(format: "%.2f",purchase!.price)
            
            // Do any additional setup after loading the view.
        }
    }
    func handleApprove(){
        performSegue(withIdentifier: "waitForVenmoSegue", sender: self)
    }
    func handleDecline(){
        self.navigationController?.popViewController(animated: true)
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextController = segue.destination as? WaitForVenmoViewController{
            nextController.user = user
            nextController.purchase = purchase
        }
    }

}
