//
//  SubmitFooterViewController.swift
//  Duke Shares Lunch
//
//  Created by Paul Dellinger on 11/27/19.
//  Copyright © 2019 July Guys. All rights reserved.
//

import UIKit

class SubmitFooterViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var commentsTextField: UITextField!
    
    @IBAction func reportAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ReportViewController") as! ReportViewController
        controller.user = self.user
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func submitAction(_ sender: Any) {
        print("button pressed!")
        let description = createDescription(meals: meals)
        print(description)
        let price = tallyPrice()
        if price>0{
            user?.createPurchase(seller: seller!, price: price, description: createDescription(meals: meals), viewController: self)
        }
        //segue here
    }

    
    
    var seller: Seller?
    var user: User?
    var meals = [Meal]()
    var purchase = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentsTextField.delegate = self

        // Do any additional setup after loading the view.
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func refreshTotal(){
        
        let cost = tallyPrice()
        let costStr = String(format: "%.2f", round(cost*100)/100)
        costLabel.text = "$\(costStr)"
        
    }
    
    func tallyPrice() -> Double{
        var cost = 0.00
        for meal in meals {
            cost += meal.price*(seller?.rate ?? 1)
        }
        return cost
    }
    func createDescription(meals: [Meal])-> String{
        var description = ""
        for meal in meals {
            description.append("\(meal.name)#")
        }
        description.append(":\(commentsTextField.text ?? " ")")
        return description
    }
    
    func handleSuccessfulInsert(pid: Int){
        // call segue here
        purchase = pid
        
        performSegue(withIdentifier: "waitForSellerSegue", sender: self)
    }
    func handleUnsuccessfulInsert(){
        let alert = UIAlertController(title: "Error Creating Purchase", message: "This is probably due to the sale being cancelled while you were ordering. Please try another seller.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                self.navigationController?.popToRootViewController(animated: true)
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
            @unknown default:
                print("unknown default")
            }}))
        self.present(alert, animated: true, completion: nil)
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let detailViewController = segue.destination as? MealSelectorTableViewController{
            detailViewController.seller = seller
            detailViewController.user = user
        }
        if let nextController = segue.destination as? WaitForSellerViewController{
            nextController.seller = seller
            nextController.user = user
            nextController.purchase = purchase
            nextController.cost = tallyPrice()
        }
    }
    
    

}
