//
//  MySalesViewController.swift
//  Duke Shares Lunch
//
//  Created by Paul Dellinger on 11/28/19.
//  Copyright © 2019 July Guys. All rights reserved.
//

import UIKit

class MySalesViewController: UIViewController {
    var user: User?
    var selected: Purchase?
    
    @IBAction func reportAction(_ sender: Any) {
        if let user = self.user{
            self.segueReport(user: user)
        }
    }
    @IBAction func pauseSalesAction(_ sender: Any) {
        user?.removeSales(viewController: self)

    }
    @IBAction func moreLocationsAction(_ sender: Any) {
        performSegue(withIdentifier: "sellAtMoreSegue", sender: self)
    }
  
    func handlePausedSales(){
        // navigationController?.popToRootViewController(animated: true)
        let child = self.children[0] as! ActiveSalesTableViewController
        child.refresh(sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        let child = self.children[0] as! ActiveSalesTableViewController
        child.refresh(sender: self)
    }
    
    func showPurchaseDetail(purchase: Purchase){
        selected = purchase
        if purchase.approve{ performSegue(withIdentifier: "salesToVenmoSegue", sender: self)
        }else{
            performSegue(withIdentifier: "showPurchaseApprovalSegue", sender: self)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let detailViewController = segue.destination as? ActiveSalesTableViewController{
            detailViewController.user = user

        }
        if let nextController = segue.destination as? PurchaseApprovalViewController{
            nextController.user = user
            nextController.purchase = selected
        }
        
        if let nextController = segue.destination as? WaitForVenmoViewController{
            nextController.user = user
            nextController.purchase = selected
        }
        if let nextController = segue.destination as? SubmitSellLocationViewController{
            nextController.user = user
        }
        
//        detailViewController?.seller = seller
    }
    

}
