//
//  LocationTableViewController.swift
//  Duke Shares Lunch
//
//  Created by Paul Dellinger on 11/12/19.
//  Copyright © 2019 July Guys. All rights reserved.
//

import UIKit



class LocationTableViewController: UITableViewController {
    
    //MARK: Properties
    var locations = [Location]()
    var user:User?
    //Global variable locations, an array of the locations we display
    
    private func loadSampleLocations() {
        // Function that loads three sample locations (call when testing)
        
        guard let location1 = Location(name: "Caprese Salad", count: 4, id: -1) else {
            fatalError("Unable to instantiate location1")
        }
        guard let location2 = Location(name: "MarketPlace", count: 20, id:-2) else {
            fatalError("Unable to instantiate location2")
        }
        guard let location3 = Location(name: "Dominos", count: 2, id:-3) else {
            fatalError("Unable to instantiate location3")
        }
        locations += [location1,location2,location3]
    }
    override func viewDidAppear(_ animated: Bool) {
        self.checkForPurchase()
        self.user?.getActiveRestaurants(completion: { restaurants, error in
            if let error = error{
                print("error getting locations: ", error)
                DispatchQueue.main.async{
                    print("Ending refresh")
                
                    self.refreshControl?.endRefreshing()
                }
            }
            if restaurants != nil{
                self.locations = restaurants!
                DispatchQueue.main.async{
                    self.updateView()
                }
            }
        })
        //getDataFromUrl(website: "https://foodpointer.pdellinger.com/activerestaurants")
    }
    
    override func viewDidLoad() {
        //required function for controller
        super.viewDidLoad()
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: .didReceivePush, object:nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: UIApplication.willEnterForegroundNotification, object: nil)
        //self.navigationController?.setNavigationBarHidden(true, animated:true);
        // print(self.tabBarController.user)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        //Make request for data, add it to locations (global variable)
        // getDataFromUrl(website: "https://foodpointer.pdellinger.com/activerestaurants")
        
    }
    @objc func refresh(){
        print("refreshing")
        //self.updateView()
        
        self.user?.getActiveRestaurants(completion: { restaurants, error in
            if let error = error{
                print("error getting locations: ", error)
                //DispatchQueue.main.async{
                    print("Ending refresh")
                    self.refreshControl?.endRefreshing()
            }
            if restaurants != nil{
                self.locations = restaurants!
                DispatchQueue.main.async{
                    self.updateView()
                }
            }
        })
        // getDataFromUrl(website: "https://foodpointer.pdellinger.com/activerestaurants")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        //required function for controller
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // required function return the number of rows in our table
        return locations.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "LocationTableViewCell"
        //identifier for cell set in storyboard
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? LocationTableViewCell  else {
            fatalError("The dequeued cell is not an instance of LocationViewCell.")
        }
        
        
        //Copy the location from the array locations into a table cell
        let location = locations[indexPath.row]
        cell.nameLabel.text = location.name
        cell.numberLabel.text = String(location.count!)
        
        // Configure the cell...

        return cell
    }
    
    private func getDataFromUrl(website: String){
        //clear existing locations, before updated ones
        //make request to addresss in parameter
        var request = URLRequest(url: URL(string: website)!,timeoutInterval: Double.infinity)
        
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
                //here data received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    data, options: [])
                
                //print(jsonResponse) //Response result
                guard let jsonArray = jsonResponse as? [[String: Any]] else {
                    return
                }
                //iterate over JSON, adding each to location
                self.locations = [Location]()
                for dic in jsonArray{
                    guard let name = dic["location"] as? String else { return }
                    guard let count = dic["count"] as? Int else { return }
                    guard let id = dic["id"] as? Int else { return }
                    //print(name, count) //Output
                    guard let location = Location(name: name, count: count, id: id) else {
                        fatalError("Unable to instantiate location")
                    }
                    self.locations += [location]
                    
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
        /*
        tableView.performBatchUpdates({ () -> Void in
            self.user?.getActiveRestaurants(completion: { restaurants, error in
                if let error = error{
                    print("error getting locations: ", error)
                    return
                }
                if restaurants != nil{
                    self.locations = restaurants!
                    return
                }
            })}, completion: { success in
                self.refreshControl?.endRefreshing()
        })*/
        tableView.reloadData()
        self.refreshControl?.endRefreshing()
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
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let selectedRestaurant = locations[indexPath.row]
//        //print(selectedRestaurant.name)
//        if let viewController = storyboard?.instantiateViewController(identifier: "LocationDetailTableViewController") as? LocationDetailTableViewController {
//            viewController.restaurant = selectedRestaurant
//            navigationController?.pushViewController(viewController, animated: true)
//        }
//    }
    private func checkForPurchase(){
        self.user?.getBuyerPurchase(completion: { purchases, error in
            if let error = error{
                print(error)
            }else{
                guard let purchases = purchases else { return }
                if purchases.count < 1 { return }
                let purchase = purchases[0]
                DispatchQueue.main.async{
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "WaitForSellerViewController") as! WaitForSellerViewController
                    controller.user = self.user
                    controller.cost = purchase.price
                    controller.seller = purchase.seller
                    controller.purchase = purchase.pid
                    self.navigationController?.pushViewController(controller, animated: true)
                    // self.present(controller, animated: true, completion: nil)
                }
                
                print(purchases)
            }
        })
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Give the restaurant selected to the next view controller (The detail page)
        guard let detailViewController = segue.destination as? LocationDetailTableViewController,
            let index = tableView.indexPathForSelectedRow?.row
            else {
                return
        }
        detailViewController.restaurant = locations[index]
        detailViewController.user = user
        //print(locations[index])
    }
    



}
