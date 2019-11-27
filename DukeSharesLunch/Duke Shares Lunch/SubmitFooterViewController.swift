//
//  SubmitFooterViewController.swift
//  Duke Shares Lunch
//
//  Created by Chris Theodore on 11/27/19.
//  Copyright © 2019 July Guys. All rights reserved.
//

import UIKit

class SubmitFooterViewController: UIViewController {
    
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var commentsTextField: UITextField!
    
    @IBAction func submitAction(_ sender: Any) {
        print("button pressed!")
        let description = createDescription(meals: meals)
        print(description)
        
        user?.createPurchase(seller: seller!, price: tallyPrice(), description: createDescription(meals: meals), viewController: self)
    }

    
    
    var seller: Seller?
    var user: User?
    var meals = [Meal]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        description.append(":\(commentsTextField.text ?? "")")
        return description
    }
    
    func handleSuccessfulInsert(pid: Int){
        // call segue here
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let detailViewController = segue.destination as? MealSelectorTableViewController
        detailViewController?.seller = seller
        detailViewController?.user = user
    }
    

}
