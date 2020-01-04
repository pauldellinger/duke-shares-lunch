//
//  ActiveSalesTableViewController.swift
//  Duke Shares Lunch
//
//  Created by Paul Dellinger on 11/29/19.
//  Copyright © 2019 July Guys. All rights reserved.
//

import UIKit

class ActiveSalesTableViewController: UITableViewController {
    
    
   
    var user: User?
    //var unapprovedPurchases = [Purchase]()
    var approvedPurchases = [Purchase]()
    var activeSales = [Seller]()
    var sales = [[Purchase](), [Purchase]()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: .didReceivePush, object:nil)
        if user?.allSales?.isEmpty ?? true{
            //add refresh spinner
            refresh(sender: self)
        }

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
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2{
            return user?.allSales?.count ?? 0
        }
        if section == 1{
            return sales[0].count
        }
        else { return sales[1].count }
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        // view.title
        //view.backgroundColor = .white
        view.tintColor = UIColor.white.withAlphaComponent(1)
      
        
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont.systemFont(ofSize: 26)
        

    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 2 { return "Your Sales"}
        if section == 1 { return "Waiting for Approval"}
        else { return "Waiting for Venmo"}
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        if section == 2 {
            if user?.allSales?.count ?? 0 > 0{
                return 50
            }else{
                return 0
            }
        }
        if section == 1{
            if sales[0].count > 0{
                return 50
            }else{
                return 0
            }
        }
        else{
            if sales[1].count > 0 {
                return 50
            }else{
                return 0
            }
        }
    }
    
    func handleSuccessfulGetSales(){
        print("calling get purchases")
        activeSales = getActivated(allSales: user?.allSales)
        user?.getPurchases(viewController: self)
        //stop refresh spinner
    }
    func handleSuccessfulGetPurchase(purchases: [[Purchase]]){
        //print(purchases)
        sales = purchases
        print(sales)
        //unapprovedPurchases = purchases
        //print(unapprovedPurchases)
        if let tabItems = tabBarController?.tabBar.items {
            // In this case we want to modify the badge number of the third tab:
            let tabItem = tabItems[1]
            let badgeCount = sales[0].count + sales[1].count
            if badgeCount > 0{
                tabItem.badgeValue = String(sales[0].count + sales[1].count)
                UIApplication.shared.applicationIconBadgeNumber = badgeCount
            }
            else {tabItem.badgeValue = nil}
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
        
        
        self.refreshControl?.endRefreshing()
        tableView.reloadData()
        //stop refresh spinner
        
    }
    func getActivated(allSales:[Seller]?) -> [Seller]{
        var active = [Seller]()
        for sale in allSales ?? []{
            if sale.status{
                active.append(sale)
            }
        }
        return active
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        let cellIdentifier = "ActiveSaleCell"
        //identifier for cell set in storyboard
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ActiveSalesTableViewCell  else {
            fatalError("The dequeued cell is not an instance of ActiveSaleCell")
        }
        
        
        //Copy the location from the array locations into a table cell
        if indexPath.section == 2{
            if let sale = user?.allSales?[indexPath.row]{
                cell.locationLabel.text = sale.locationName
                cell.rateLabel.text = "\(Int(sale.rate*100))%"
                
                // String(format: "%.2f", sale.rate)
                let ordertime = timeUntilOrder(ordertime: sale.ordertime)
                if ordertime > 0 {
                    cell.timeLabel.text = "\(ordertime) minutes until ordering"
                }
                else {
                    cell.timeLabel.text = "\(ordertime * -1) minutes past ordertime"
                }
                //cell.timeLabel.text = sale.ordertime
                var count = 0
                for purchase in sales[0]{
                    print(purchase.seller.locationName, sale.locationName)
                    if purchase.seller.locationName == sale.locationName{
                        count = count + 1
                        print(count)
                    }
                }
                if count>0{
                    cell.buyerCountLabel.text = String(count)
                    cell.notifyCircle.alpha = 1
                } else{
                    cell.buyerCountLabel.alpha = 0
                    cell.notifyCircle.alpha = 0
                }
            }
            
        }
        if indexPath.section == 1{
            let sale = sales[0][indexPath.row]
            cell.locationLabel.text = sale.buyer.name
            cell.rateLabel.text = "$\(String(format: "%.2f", sale.price))"
            cell.timeLabel.text = sale.seller.locationName
//            let ordertime = timeUntilOrder(ordertime: sale.seller.ordertime)
//            if ordertime > 0 {
//                cell.timeLabel.text = "\(ordertime) minutes until ordering"
//            }
//            else {
//                cell.timeLabel.text = "\(ordertime * -1) minutes past ordertime"
//            }
//            // cell.timeLabel.text = sale.seller.ordertime
            cell.buyerCountLabel.text = ""
            cell.notifyCircle.alpha = 0
        }
        
        if indexPath.section == 0 {
            //the labels don't match up because I want to reuse the cell class
            let sale = sales[1][indexPath.row]
            cell.locationLabel.text = sale.buyer.name
            cell.rateLabel.text = "$\(String(format: "%.2f", sale.price))"
            let ordertime = timeUntilOrder(ordertime: sale.seller.ordertime)
            if ordertime > 0 {
                cell.timeLabel.text = "\(ordertime) minutes until ordering"
            }
            else {
                cell.timeLabel.text = "\(ordertime * -1) minutes past ordertime"
            }
            // cell.timeLabel.text = sale.seller.ordertime
            cell.buyerCountLabel.text = ""
            cell.notifyCircle.alpha = 0
            
        }

        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // print(indexPath)
        if indexPath.section == 2{
            if let sale = user?.allSales?[indexPath.row]{
                print(sale.saleid)
                //print(sales[0][0].seller.saleid)
                for purchase in sales[0]{
                    if purchase.seller.locationName == sale.locationName{
                        let parent = self.parent as! MySalesViewController
                        print("giving purchase to parent", purchase.seller.locationName)
                        parent.showPurchaseDetail(purchase: purchase)
                    }
                }
            }
        }
        if indexPath.section == 1 {
            let parent = self.parent as! MySalesViewController
            parent.showPurchaseDetail(purchase: sales[0][indexPath.row])
        }
        if indexPath.section == 0{
            let sale = sales[1][indexPath.row]
            let parent = self.parent as! MySalesViewController
            parent.showPurchaseDetail(purchase: sale)
        }
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        let cellIdentifier = "ActiveSaleCell"
               //identifier for cell set in storyboard
               guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ActiveSalesTableViewCell  else {
                   fatalError("The dequeued cell is not an instance of ActiveSaleCell")
               }
        if indexPath[0] == 0{
            //if cell.notifyCircle.alpha == 1 { return false }
        }
        return true
    }

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if indexPath.section == 2{
                // Delete the row from the data source
                if let sale = user?.allSales?[indexPath.row]{
                    sale.remove(token:user?.token ?? "", viewController:self)
                }
            }
            if indexPath.section == 1 {
                let sale = sales[0][indexPath.row]
                sale.decline(user: self.user!, viewController: self)
            }
            if indexPath.section == 0{
                let sale = sales[1][indexPath.row]
                sale.decline(user: self.user!, viewController: self)
            }
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // this will turn on `masksToBounds` just before showing the cell
        cell.contentView.layer.masksToBounds = true
        let radius = cell.contentView.layer.cornerRadius
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: radius).cgPath
    }
    
    func handleSaleRemoval(){
        refresh(sender:self)
    }
    func timeUntilOrder(ordertime: String) -> Int{
        if ordertime.isEmpty { return 0 }
        let ordertimeFixed = ordertime.replacingOccurrences(of: "T", with: " ")
        print(ordertimeFixed)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let current = Date()
        // print(current)
        let time = formatter.date(from: ordertimeFixed)
        if let interval = (time?.timeIntervalSince(current)){
            let minuteDifference = Int((interval/60).rounded(.up))
            return minuteDifference
        } else { return 0 }
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
