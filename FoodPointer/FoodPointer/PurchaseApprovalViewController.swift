//
//  PurchaseApprovalViewController.swift
//  Duke Shares Lunch
//
//  Created by Paul Dellinger on 11/30/19.
//  Copyright © 2019 July Guys. All rights reserved.
//

import UIKit

class PurchaseApprovalViewController: UIViewController {
    
    
    var user: User?
    var purchase: Purchase?
    
    @IBAction func reportAction(_ sender: Any) {
        if let user = self.user{
            self.segueReport(user: user)
        }
    }
    @IBOutlet weak var buyerNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var foodPointCostLabel: UILabel!
    @IBOutlet weak var realMoneyLabel: UILabel!
    @IBAction func declineAction(_ sender: Any) {
        purchase?.decline(user:user!, viewController: self)
    }
    
    @IBAction func approveAction(_ sender: Any) {
        purchase?.approve(user:user!, completion: { error in
            if let error = error{
                if error == 404 {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Purchase Not Found", message: "It seems the buyer deleted this purchase.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                            switch action.style{
                            case .default:
                                self.navigationController?.popToRootViewController(animated: true)
                                print("default")
                                
                            case .cancel:
                                print("cancel")
                                
                            case .destructive:
                                print("destructive")
                                
                            }}))
                        self.present(alert, animated: true, completion: nil)
                    }
                }else{
                    print("mark paid error: ", error)
                }
            }else{
                DispatchQueue.main.async{
                    self.performSegue(withIdentifier: "waitForVenmoSegue", sender: self)
                }
            }
        })
        
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
            foodPointCostLabel.text = "$\(String(format: "%.2f", purchase!.price * (1.0/(purchase?.seller.rate)!)))"
            realMoneyLabel.text = "$\(String(format: "%.2f",purchase!.price))"
            
            // Do any additional setup after loading the view.
        }
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
