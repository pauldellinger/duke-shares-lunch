//
//  Seller.swift
//  Duke Shares Lunch
//
//  Created by Paul Dellinger on 11/13/19.
//  Copyright © 2019 July Guys. All rights reserved.
//

import UIKit

class Seller{
    
    //MARK: Properties
    var saleid: Int
    var sellerId: String
    var status: Bool
    var locationName: String
    var sellerName : String
    var sellerVenmo: String
    var rate: Double
    var ordertime: String
    
    
    init?(saleid: Int, sellerId: String, status: Bool, locationName: String, sellerName : String, sellerVenmo: String, rate: Double, ordertime: String) {
        self.saleid = saleid
        self.sellerId = sellerId
        self.status = status
        self.sellerName = sellerName
        self.locationName = locationName
        self.sellerVenmo = sellerVenmo
        self.rate = rate
        self.ordertime = ordertime
        // Initialization should fail if there is no name or if the rating is negative.
        if locationName.isEmpty || (rate < 0 || rate>1 ){
            return nil
        }
    }
    init?(json: [String: Any]) {
        guard let locationName = json["location"] as? String else {
            print("Problem with location  statement or data input")
            return nil
        }
        guard let sellerJSON = json["seller"] as? [String: String] else {
            print("Problem with seller  statement or data input")
            return nil
        }
        guard let sellerVenmo = sellerJSON["venmo"] else {
            print("Problem with sellerVenmo statement or data input")
            return nil
        }
        guard let sellerName = sellerJSON["name"] else {
            print("Problem with sellerName statement or data input")
            return nil
        }
        guard let sellerId = json["uid"] as? String else {
            print("Problem with sellerId statement or data input")
            return nil
        }
        guard let saleid = json["saleid"] as? Int else {
            print("Problem with saleId statement or data input")
            return nil
        }
        guard let ordertime = json["ordertime"] as? String else {
            print("Problem with ordertime statement or data input")
            return nil
        }
        guard let percent = json["percent"] as? Double else {
            print("Problem with rate statement or data input")
            return nil
        }
        guard let status = json["status"] as? Bool else {
            print("Problem with status statement or data input")
            return nil
        }
            
        
        self.saleid = saleid
        self.sellerId = sellerId
        self.status = status
        self.sellerName = sellerName
        self.locationName = locationName
        self.sellerVenmo = sellerVenmo
        self.rate = percent
        self.ordertime = ordertime
    }
    
    func remove(token: String, viewController: Any?){
        print("Removing from ActiveSeller!")
        let scheme = "https"
        let host = "pdellinger.com"
        let path = "/activeseller"
        let queryItem = URLQueryItem(name: "saleid", value: "eq.\(self.saleid)")
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        urlComponents.queryItems = [queryItem]

        guard let url = urlComponents.url else { return }
        var request = URLRequest(url: url,timeoutInterval: Double.infinity)
        print(url)
        request.httpMethod = "DELETE"
        //specify type of request
        
        //authorization
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        print(request)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                print("status code \(httpResponse.statusCode)")
                if httpResponse.statusCode == 204 {
                    print("Sale Deleted Deleted!")
                    if let viewController = viewController as? ActiveSalesTableViewController{
                        DispatchQueue.main.async{
                            viewController.handleSaleRemoval()
                        }
                    }
                    //call handle function in main queue
                }
                else{
                    print("Did not get 204 code, something went wrong")
                }
            }
        }
        //We have to call the task here because it's asynchronous
        task.resume()
    }

    
}


