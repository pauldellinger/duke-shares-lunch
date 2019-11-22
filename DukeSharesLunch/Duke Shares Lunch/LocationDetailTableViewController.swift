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
    
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated:true);
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        //let website = "http://35.194.58.92/activeseller?select=saleid,uid,registereduser(name,venmo),ordertime,status,percent,location"
        //print(restaurant)
        
        getDataFromUrl()
        
    }

    // MARK: - Table view data source

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
        let host = "35.194.58.92"
        let path = "/activeseller"
        let queryItem = URLQueryItem(name: "select", value: "saleid,uid,seller:registereduser(name,venmo),ordertime,status,percent,location")
        let restaurantEquality = "eq." + restaurant!.name
        let queryItem2 = URLQueryItem(name: "location", value: restaurantEquality)

        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        urlComponents.queryItems = [queryItem]
        urlComponents.queryItems! += [queryItem2]
        

        guard let url = urlComponents.url else { return }
        //make request to addresss in parameter
        var request = URLRequest(url: url,timeoutInterval: Double.infinity)

        //specify type of request
        request.httpMethod = "GET"

        //authorization
        request.setValue("Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidG9kb191c2VyIn0.IWnJCBgXAYfPGA-zB4JPlcAGfDYkwTwCTmQM-boguV8", forHTTPHeaderField: "Authorization")

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
           let hasSellers = sellers.count > 0

           if hasSellers{
               tableView.reloadData()
           }
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
        cell.rate.text = String(seller.rate)
        cell.ordertime.text = seller.ordertime
        // Configure the cell...
        
        return cell
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
