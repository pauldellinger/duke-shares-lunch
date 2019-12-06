//
//  ActiveSalesTableViewController.swift
//  Duke Shares Lunch
//
//  Created by Chris Theodore on 11/29/19.
//  Copyright © 2019 July Guys. All rights reserved.
//

import UIKit

class ActiveSalesTableViewController: UITableViewController {
    
    
   
    var user: User?
    var unapprovedPurchases = [Purchase]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        if user?.activeSales?.isEmpty ?? true{
            //add refresh spinner
            refresh(sender: self)
        }
        user?.getPurchases(viewController: self)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source
    @objc func refresh(sender:AnyObject){
        refreshControl?.beginRefreshing()
        user?.getUserSales(viewcontroller: self)
        
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return user?.activeSales?.count ?? 0
    }
    func handleSuccessfulGetSales(){
        print("calling get purchases")
        user?.getPurchases(viewController: self)
        //stop refresh spinner
    }
    func handleSuccessfulGetPurchase(purchases: [Purchase]){
        //print(purchases)
        unapprovedPurchases = purchases
        print(unapprovedPurchases)
        self.refreshControl?.endRefreshing()
        tableView.reloadData()
        //stop refresh spinner
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        let cellIdentifier = "ActiveSaleCell"
        //identifier for cell set in storyboard
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ActiveSalesTableViewCell  else {
            fatalError("The dequeued cell is not an instance of ActiveSaleCell")
        }
        
        
        //Copy the location from the array locations into a table cell
        
        if let sale = user?.activeSales?[indexPath.row]{
            cell.locationLabel.text = sale.locationName
            cell.rateLabel.text = String(format: "%.2f", sale.rate)
            cell.timeLabel.text = sale.ordertime
            var count = 0
            for purchase in unapprovedPurchases{
                print(purchase.seller.locationName, sale.locationName)
                if purchase.seller.locationName == sale.locationName{
                    count = count + 1
                    print(count)
                }
            }
            cell.buyerCountLabel.text = String(count)
        }

        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let sale = user?.activeSales?[indexPath.row]{
            for purchase in unapprovedPurchases{
                if purchase.seller.locationName == sale.locationName{
                    let parent = self.parent as! MySalesViewController
                    parent.showPurchaseDetail(purchase: purchase)
                }
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

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            if let sale = user?.activeSales?[indexPath.row]{
                for purchase in unapprovedPurchases{
                    if purchase.seller.locationName == sale.locationName{
                        purchase.decline(user: user!, viewController: self)
                        refreshControl?.beginRefreshing()
                    }
                    user?.activeSales?.remove(at: indexPath[1])
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
        func handleDecline(){
            refreshControl?.endRefreshing()
        }
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
