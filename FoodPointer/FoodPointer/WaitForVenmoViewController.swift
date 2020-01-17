//
//  WaitForVenmoViewController.swift
//  Duke Shares Lunch
//
//  Created by Paul Dellinger on 11/30/19.
//  Copyright © 2019 July Guys. All rights reserved.
//

import UIKit

class WaitForVenmoViewController: UIViewController {

    @IBAction func reportAction(_ sender: Any) {
        if let user = self.user{
            self.segueReport(user: user)
        }
    }
    @IBOutlet weak var contentLabel: UILabel!
    @IBAction func venmoCompleteAction(_ sender: Any) {
        
        purchase?.markPaid(user:user!, viewController:self)
    }
    @IBAction func cancelOrderAction(_ sender: Any) {
        purchase?.decline(user: user!, viewController: self)
    }
    
    var user: User?
    var purchase: Purchase?
    override func viewDidLoad() {
        super.viewDidLoad()
        if purchase?.paid ?? false{ performSegue(withIdentifier: "buyFoodSegue", sender: self) }
        contentLabel.text = "Did \(purchase!.buyer.name!) (\(purchase!.buyer.venmo!)) venmo you?"
        // Do any additional setup after loading the view.
    }
    func handlePaid(){
        performSegue(withIdentifier: "buyFoodSegue", sender: self)
    }
    func handleDecline(){
        navigationController?.popToRootViewController(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
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
