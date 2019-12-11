//
//  LocationDetailTableViewController.swift
//  Duke Shares Lunch
//
//  Created by Paul Dellinger on 11/13/19.
//  Copyright © 2019 July Guys. All rights reserved.
//

import UIKit

class LocationDetailTableViewController: UITableViewController {
    
    var sellers = [Seller]()
    var restaurant:Location?
    
    var user: User?
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated:true);
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        //let website = "http://35.194.58.92/activeseller?select=saleid,uid,registereduser(name,venmo),ordertime,status,percent,location"
        //print(restaurant)
        //self.refreshControl?.beginRefreshing()
        getDataFromUrl()
        
    }

    // MARK: - Table view data source
    @objc func refresh(sender:AnyObject)
    {
        // Updating your data here...
        getDataFromUrl()
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sellers.count
    }
    private func getDataFromUrl(){
        
        
        let scheme = "http"
        let host = "35.193.85.182"
        let path = "/activeseller"
        let queryItem = URLQueryItem(name: "select", value: "saleid,uid,seller:registereduser(name,venmo),ordertime,status,percent,location")
        let restaurantEquality = "eq." + restaurant!.name
        let queryItem2 = URLQueryItem(name: "location", value: restaurantEquality)
        let queryItem3 = URLQueryItem(name: "order", value: "percent")
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        urlComponents.queryItems = [queryItem]
        urlComponents.queryItems! += [queryItem2]
        urlComponents.queryItems! += [queryItem3]
        
        guard let url = urlComponents.url else { return }
        //make request to addresss in parameter
        var request = URLRequest(url: url,timeoutInterval: Double.infinity)

        //specify type of request
        request.httpMethod = "GET"

        //authorization
        request.setValue("Bearer \(user?.token ?? "")", forHTTPHeaderField: "Authorization")

        //Use the URLSession built in to make a dataTask (basically a request)

        //Initialize three vars  - data, response and error

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            do{
                print(data)
                //here data received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    data, options: [])

                print(jsonResponse) //Response result
                guard let jsonArray = jsonResponse as? [[String: Any]] else {
                    return
                }
                print(jsonArray)
                //iterate over JSON, adding each to location
                
                //clear sellers before we add to them
                
                self.sellers = [Seller]()
                for dic in jsonArray{

                    guard let seller = Seller(json:dic) else {
                        fatalError("Unable to instantiate seller")
                    }
                    self.sellers += [seller]

                }
                //reload the table with the new values
                DispatchQueue.main.async {
                    self.updateView()
                }
            //Response not in JSON format
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        //We have to call the task here because it's asynchronous
        task.resume()
        }
    
    
    private func updateView() {
        //This function updates the table
        tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "LocationDetailTableViewCell"
        //identifier for cell set in storyboard
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? LocationDetailTableViewCell  else {
            fatalError("The dequeued cell is not an instance of LocationDetailViewCell.")
        }
        
        
        //Copy the location from the array locations into a table cell
        
        let seller = sellers[indexPath.row]
        cell.name.text = seller.sellerName
        cell.rate.text = "\(Int((1-seller.rate)*100))% off"
        let ordertime = timeUntilOrder(ordertime: seller.ordertime)
        if ordertime > 0 {
            cell.ordertime.text = "\(ordertime) minutes until ordering"
        }
        else {
            cell.ordertime.text = "Ready Now!"
        }
        // Configure the cell...
        
        return cell
    }
    func timeUntilOrder(ordertime: String) -> Int{
        print(ordertime)
        if ordertime.isEmpty { return 0 }
        let ordertimeFixed = ordertime.replacingOccurrences(of: "T", with: " ")
        print(ordertimeFixed)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let current = Date()
        // print(current)
        let time = formatter.date(from: ordertimeFixed)
        print("from psql:", time)
        if let interval = (time?.timeIntervalSince(current)){
            let minuteDifference = Int((interval/60).rounded(.up))
            return minuteDifference
        } else { return 0 }
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.

        guard let detailViewController = segue.destination as? SubmitFooterViewController,
            let index = tableView.indexPathForSelectedRow?.row
            else {
                return
        }
        print("handing over seller: ", sellers[index])
        detailViewController.seller = sellers[index]
        detailViewController.user = user
    
        
    }
    

}
