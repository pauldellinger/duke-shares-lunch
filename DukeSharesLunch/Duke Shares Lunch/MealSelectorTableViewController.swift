//
//  MealSelectorTableViewController.swift
//  Duke Shares Lunch
//
//  Created by Chris Theodore on 11/23/19.
//  Copyright © 2019 July Guys. All rights reserved.
//

import UIKit

class MealSelectorTableViewController: UITableViewController {
    
    var seller: Seller?
    var user: User?
    var meals = [Meal]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.allowsMultipleSelection = true
        tableView.delegate = self
        tableView.dataSource = self
        
        
        loadMeals(restaurant: seller!.locationName)
        refreshFooter()
    
        // print(meals)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    /*

    // set view for footer
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 100))
        // footerView.becomeFirstResponder()
        
        footerView.backgroundColor = UIColor.black
        
        // set up button
        let button = UIButton(frame: CGRect(x: tableView.frame.size.width-100, y: 40, width: 100, height: 50))
        button.setTitle("Submit", for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        footerView.addSubview(button)
        
        // set up total
        
        var cost = 0.00
        let selected = self.tableView.indexPathsForSelectedRows
        print(selected)
        for (index, meal) in meals.enumerated() {
            let myRow = IndexPath(row: index, section:0)
            if selected?.contains(myRow) ?? false {
                //print(meal.name)
                cost += meal.price*(seller?.rate ?? 1)
            }
        }
        
        let total = UILabel(frame: CGRect(x:0, y:0, width: tableView.frame.size.width-25, height: 40))
        total.textAlignment = NSTextAlignment.right
        total.textColor = UIColor.white
        
        let costStr = String(format: "%.2f", round(cost*100)/100)
        total.text = "$\(costStr)"
        footerView.addSubview(total)
        
        //set up comments for seller textfield
        let comments =  UITextField(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width-100, height: 80))
        comments.attributedPlaceholder = NSAttributedString(string: "placeholder text",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        comments.placeholder = "Add comments on order"
        comments.font = UIFont.systemFont(ofSize: 15)
        // comments.borderStyle = UITextField.BorderStyle.roundedRect
        comments.autocorrectionType = UITextAutocorrectionType.no
        comments.keyboardType = UIKeyboardType.default
        comments.returnKeyType = UIReturnKeyType.done
        comments.clearButtonMode = UITextField.ViewMode.whileEditing
        comments.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        comments.textColor = UIColor.white

        
        footerView.addSubview(comments)
        return footerView
    }


    // set height for footer
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 80
    }
 */
    /*
    @objc func buttonAction(_ sender: UIButton!) {
        print("Button tapped")
        //handle no selection
        let subviews = tableView.subviews
        for view in subviews{
            print(view)
            print(view.subviews)
        }
        
        var description = createDescription()
        print(description)
    }
 */
    
    
    func loadMeals(restaurant: String){
        if let path = Bundle.main.path(forResource: "restaurants", ofType: "json") {
            do {
                  let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                  let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                    // print(jsonResult)
                guard let jsonArray = jsonResult as? [[String: Any]] else {
                    return
                }
                for dic in jsonArray{
                    guard let westunion = dic["West Union"] as? [[String:Any]] else {return}
                    for place in westunion{
                        if (place["name"] as! String? == restaurant){
                            guard let menu = place["menu"] as? [[String:Any]] else { return }
                            for item in menu {
                                // print(item["name"]!, item["price"]!)
                                let meal = Meal(name:item["name"] as! String, price: item["price"] as! Double)
                                meal?.price *= 1.075 //Durham tax at WU
                                print(meal)
                                meals += [meal!]
                            }
                        }
                    }
                    
                }
            
              } catch {
                print("Unable to read json with the meals")
                return
              }
        }
        
    }
    
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return meals.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "MealSelectorTableViewCell"
        //identifier for cell set in storyboard
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MealSelectorTableViewCell  else {
            fatalError("The dequeued cell is not an instance of MealSelectorTableViewCell.")
        }
        // Configure the cell...
        
        let meal = meals[indexPath.row]
        cell.nameLabel.text = meal.name
        let cost = meal.price * seller!.rate
        let costStr = String(format: "%.2f", round(cost*100)/100)
        cell.priceLabel.text = "$\(costStr)"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        refreshFooter()
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath){
        refreshFooter()

    }
    func refreshFooter(){
        let parent = self.parent as? SubmitFooterViewController
        parent?.meals = [Meal]()
        let selected = self.tableView.indexPathsForSelectedRows
        for (index, meal) in meals.enumerated() {
            
            let myRow = IndexPath(row: index, section:0)
            if selected?.contains(myRow) ?? false {
                // print(meal.name)
                parent?.meals += [meal]
            }
        }
        parent?.refreshTotal()
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
