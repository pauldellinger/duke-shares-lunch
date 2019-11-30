//
//  SellLocationTableViewController.swift
//  Duke Shares Lunch
//
//  Created by Chris Theodore on 11/27/19.
//  Copyright © 2019 July Guys. All rights reserved.
//

import UIKit

class SellLocationTableViewController: UITableViewController {
    
    var locations = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.allowsMultipleSelection = true
        loadLocations()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return locations.count
    }
    
    func loadLocations(){
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
                        locations += [place["name"] as! String]
                        
                    /*
                        if (place["name"] as! String? == restaurant){
                            guard let menu = place["menu"] as? [[String:Any]] else { return }
                            for item in menu {
                                // print(item["name"]!, item["price"]!)
                                let meal = Meal(name:item["name"] as! String, price: item["price"] as! Double)
                                 += [meal!]

                            }
                        }
                        */
                    }
                    
                }
                tableView.reloadData()
            
              } catch {
                print("Unable to read json with the meals")
                return
              }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...
        
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "SellLocationTableViewCell"
        //identifier for cell set in storyboard
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SellLocationTableViewCell  else {
            fatalError("The dequeued cell is not an instance of SellLocationViewCell.")
        }
        
        
        //Copy the location from the array locations into a table cell
        let location = locations[indexPath.row]
        cell.nameLabel.text = location
        
        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        refreshParent()
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath){
        refreshParent()

    }
    func refreshParent(){
        let parent = self.parent as? SubmitSellLocationViewController
        parent?.selectedLocations = [String]()
        let selected = self.tableView.indexPathsForSelectedRows
        for (index, location) in locations.enumerated() {
            
            let myRow = IndexPath(row: index, section:0)
            if selected?.contains(myRow) ?? false {
                // print(meal.name)
                parent?.selectedLocations += [location]
            }
        }
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
