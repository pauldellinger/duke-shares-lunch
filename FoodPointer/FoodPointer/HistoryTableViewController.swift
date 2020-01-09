//
//  HistoryTableViewController.swift
//  FoodPointer
//
//  Created by Paul Dellinger on 1/4/20.
//  Copyright © 2020 July Guys. All rights reserved.
//

import UIKit

class HistoryTableViewController: UITableViewController {
    
    var user:User?
    
    var purchases = [[String:Any]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        //print("history user ", self.user?.uid)
        self.user?.getHistory(completion: { transactions, error in
            if let error = error {
                print("history error: ", error)
            }
            guard let transactions = transactions else{
                print("no transaction returned")
                return
            }
            print(transactions)
            self.purchases = transactions
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
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
        return self.purchases.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell", for: indexPath) as? HistoryTableViewCell else {
            fatalError("History cell is not the right type")
        }
        let purchase = purchases[indexPath.row]
        
        var dateTime = purchase["complete_time"] as! String
        print(dateTime)
        //dateTime = dateTime.replacingOccurrences(of:":", with:"")
        //dateTime = dateTime.replacingOccurrences(of: "-", with: "")
        let dateTimeComponents = dateTime.components(separatedBy: ".")
        dateTime = dateTimeComponents[0]
        
        dateTime += "Z"
        print(dateTime)
        let iso8601format = ISO8601DateFormatter()

        guard let iso8601 = iso8601format.date(from: dateTime) else {
            print("error converting date to iso8601")
            return cell
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/DD hh:MM"
        let converted = formatter.string(from: iso8601)
        cell.dateLabel.text = converted
        
        
        
        let buyer = purchase["buyer"] as! [String:String]
        cell.buyerLabel.text = "Buyer: " + (buyer["name"] ?? "")
        let seller = purchase["seller"] as! [String:String]
        cell.sellerLabel.text = "Seller: " + (seller["name"] ?? "")
        
        let approve = purchase["approve"] as! Bool
        if approve{
            cell.approveLabel.text = "Approved: Yes"
        } else{
            cell.approveLabel.text = "Approved: No"
        }
        let paid = purchase["paid"] as! Bool
        if paid{
            cell.paidLabel.text = "Paid: Yes"
        } else{
            cell.paidLabel.text = "Paid: No"
        }
        let description = purchase["description"] as! String
        cell.itemsLabel.text = description.replacingOccurrences(of: "#", with: "\n", options: .literal, range: nil).replacingOccurrences(of: ":", with: "Notes: ")
        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .none
            let parent = self.parent as? ReportViewController
            parent?.selected = nil
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
            let hid = purchases[indexPath.row]["hid"] as? Int
            let parent = self.parent as? ReportViewController
            parent?.selected = hid

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
