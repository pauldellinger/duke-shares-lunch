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
        
        //purchase?.markPaid(user:user!, viewController:self)
        purchase?.markPaid(user:user!, completion: { error in
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
                    self.performSegue(withIdentifier: "buyFoodSegue", sender: self)
                }
            }
        })
    }
    @IBAction func cancelOrderAction(_ sender: Any) {
        purchase?.decline(user: user!, viewController: self)
    }
    
    var user: User?
    var purchase: Purchase?
    override func viewDidLoad() {
        super.viewDidLoad()
        if purchase?.paid ?? false{ performSegue(withIdentifier: "buyFoodSegue", sender: self) }
        contentLabel.text = "Did \(purchase!.buyer.name!) (\(purchase!.buyer.venmo!)) venmo you $\(purchase!.price)?"
        // Do any additional setup after loading the view.
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
