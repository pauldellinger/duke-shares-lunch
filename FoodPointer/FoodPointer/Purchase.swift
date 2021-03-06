//
//  Purchase.swift
//  Duke Shares Lunch
//
//  Created by Paul Dellinger on 11/29/19.
//  Copyright © 2019 July Guys. All rights reserved.
//

import UIKit

class Purchase {
    
    var pid: Int
    var seller: Seller
    var buyer: User
    var price: Double
    var approve: Bool
    var paid: Bool
    var description: String
    
    init?(pid: Int, seller: Seller, buyer: User,price: Double, approve: Bool, paid: Bool, description: String) {
        self.pid = pid
        self.seller = seller
        self.buyer = buyer
        self.price = price
        self.approve = approve
        self.paid = paid
        self.description = description

    }
    
    func approve(user: User, completion: @escaping ( _ error: Int?)-> ()){
        print("Approving purchase!")
        let scheme = "https"
        let host = "foodpointer.pdellinger.com"
        let path = "/purchase"
        let queryItem = URLQueryItem(name: "pid", value: "eq.\(self.pid)")
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        urlComponents.queryItems = [queryItem]

        guard let url = urlComponents.url else { return }
        var request = URLRequest(url: url,timeoutInterval: Double.infinity)
        print(url)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PATCH"
        let parameters = "approve=true"
        let postData =  parameters.data(using: .utf8)
        request.httpBody = postData
        //specify type of request
        
        //authorization
        request.setValue("Bearer \(user.token!)", forHTTPHeaderField: "Authorization")
        
        print(request)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil{
                DispatchQueue.main.async{
                    NotificationBanner.show("Connection Error")
                }
                completion(-1)
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                print("status code \(httpResponse.statusCode)")
                if httpResponse.statusCode == 204 {
                    print("Purchase Approved!")
                    //call handle function in main queue
                    completion(nil)
                } else{
                    completion(httpResponse.statusCode)
                }
            }
        }
        //We have to call the task here because it's asynchronous
        task.resume()
        

    }
    func decline(user: User, viewController: Any?){
        print("Removing purchase!")
        let scheme = "https"
        let host = "foodpointer.pdellinger.com"
        let path = "/purchase"
        let queryItem = URLQueryItem(name: "pid", value: "eq.\(self.pid)")
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
        request.setValue("Bearer \(user.token!)", forHTTPHeaderField: "Authorization")
        
        print(request)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil{
                DispatchQueue.main.async{
                    NotificationBanner.show("Connection Error")
                }
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                print("status code \(httpResponse.statusCode)")
                if httpResponse.statusCode == 204 {
                    print("Purchase Deleted!")
                    if let viewController = viewController as? PurchaseApprovalViewController{
                        DispatchQueue.main.async{
                            viewController.handleDecline()
                        }
                    }
                    if let viewController = viewController as? WaitForVenmoViewController{
                        DispatchQueue.main.async{
                            viewController.handleDecline()
                        }
                    }
                    
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
    
    func markPaid(user: User, completion: @escaping ( _ error: Int?)-> ()){
        print("Approving purchase!")
        let scheme = "https"
        let host = "foodpointer.pdellinger.com"
        let path = "/purchase"
        let queryItem = URLQueryItem(name: "pid", value: "eq.\(self.pid)")
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        urlComponents.queryItems = [queryItem]

        guard let url = urlComponents.url else { return }
        var request = URLRequest(url: url,timeoutInterval: Double.infinity)
        print(url)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PATCH"
        let parameters = "paid=true"
        let postData =  parameters.data(using: .utf8)
        request.httpBody = postData
        //specify type of request
        
        //authorization
        request.setValue("Bearer \(user.token!)", forHTTPHeaderField: "Authorization")
        
        print(request)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil{
                DispatchQueue.main.async{
                    NotificationBanner.show("Connection Error")
                }
                completion(-1)
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                print("status code \(httpResponse.statusCode)")
                if httpResponse.statusCode == 204 {
                    print("Purchase Approved!")
                    //call handle function in main queue
                    completion(nil)
                }else{
                    print("Did not get 204 code, something went wrong")
                    completion(httpResponse.statusCode)
                }
            }
        }
        //We have to call the task here because it's asynchronous
        task.resume()
        
    }
    func complete(user: User, viewController: BuyFoodViewController?){
        print("completing purchase!")
        let scheme = "https"
        let host = "foodpointer.pdellinger.com"
        let path = "/purchase"
        let queryItem = URLQueryItem(name: "pid", value: "eq.\(self.pid)")
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        urlComponents.queryItems = [queryItem]

        guard let url = urlComponents.url else { return }
        var request = URLRequest(url: url,timeoutInterval: Double.infinity)
        print(url)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "DELETE"
        //specify type of request
        
        //authorization
        request.setValue("Bearer \(user.token!)", forHTTPHeaderField: "Authorization")
        
        print(request)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil{
                DispatchQueue.main.async{
                    NotificationBanner.show("Connection Error")
                }
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                print("status code \(httpResponse.statusCode)")
                if httpResponse.statusCode == 204 {
                    print("Purchase Deleted!")
                    //call handle function in main queue
                    if let viewController = viewController{
                        DispatchQueue.main.async{
                            viewController.handleComplete()
                        }
                    }
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
