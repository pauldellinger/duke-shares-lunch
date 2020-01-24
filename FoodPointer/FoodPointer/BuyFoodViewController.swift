//
//  BuyFoodViewController.swift
//  Duke Shares Lunch
//
//  Created by Paul Dellinger on 11/30/19.
//  Copyright © 2019 July Guys. All rights reserved.
//

import UIKit

class BuyFoodViewController: UIViewController {
    
    @IBAction func reportAction(_ sender: Any) {
        if let user = self.user{
            self.segueReport(user: user)
        }
    }
    @IBAction func completePurchaseAction(_ sender: Any) {
        self.purchase?.complete(user: self.user!, viewController:self)
    }
    var purchase: Purchase?
    var user: User?
    @IBOutlet weak var buyerNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet weak var foodPointCostLabel: UILabel!
    @IBOutlet weak var realMoneyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if var description = purchase?.description.components(separatedBy: "*"){
            print(description)
            if let buyerName = purchase?.buyer.name{
                buyerNameLabel.text = "\(buyerName) would like:"
            }
            descriptionLabel.text = ""
            let notes = description.removeLast()
            let meals = description
            print("meals :", meals)
            for item in meals{
                descriptionLabel.text = descriptionLabel.text! + "\n• \(item)"
            }
            descriptionLabel.text = (descriptionLabel!.text ?? "") + "\n"+"Notes: \(notes)"
            foodPointCostLabel.text = "$\(String(format: "%.2f", purchase!.price * (1.0/(purchase?.seller.rate)!)))"
            realMoneyLabel.text = "$\(String(format: "%.2f",purchase!.price))"
            
            // Do any additional setup after loading the view.
        }
        // Do any additional setup after loading the view.
    }
    func handleComplete(){
        navigationController?.popToRootViewController(animated: true)
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
