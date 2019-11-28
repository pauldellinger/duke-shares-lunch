//
//  User.swift
//  Duke Shares Lunch
//
//  Created by Paul Dellinger on 11/15/19.
//  Copyright © 2019 July Guys. All rights reserved.
//

import UIKit

class User {
    
    //MARK: Properties
    
    var uid: Int?
    var name: String?
    var password: String
    var email: String
    var token: String?
    var venmo: String?
    var major: String?
    var dorm: String?
    
    init? (email:String, password:String ){

        self.email = email
        self.password = password
        if email.isEmpty || password.isEmpty {
            return nil
        }
    }
    func createUser(){
        let parameters = "{ \"email\": \"\(self.email)\", \"pass\": \"\(self.password)\" }"
        let postData = parameters.data(using: .utf8)
        var request = URLRequest(url: URL(string: "http://35.194.58.92/rpc/make_user")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        request.httpBody = postData
        //make request to addresss in parameter
        
        //specify type of request
        request.httpMethod = "POST"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            do{
                if let text = String(data: data, encoding: .utf8) {
                    //And then into Int
                    if let value = Int(text) {
                        print(value)
                        if value==1{
                            print("User Creation Successful")
                        }
                    } else {
                        print("text cannot be converted to Int")
                    }
                } else {
                    print("data is not in UTF-8")
                }
                    
                //reload the table with the new values
                //Response not in JSON format
            }
        }
        //We have to call the task here because it's asynchronous
        task.resume()

    }
        
    func login(viewController: UserPageViewController?){
        
        let parameters = "{ \"email\": \"\(self.email)\", \"pass\": \"\(self.password)\" }"
        let postData = parameters.data(using: .utf8)
        var request = URLRequest(url: URL(string: "http://35.194.58.92/rpc/login")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        request.httpBody = postData
        //make request to addresss in parameter
        
        //specify type of request
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                print("status code \(httpResponse.statusCode)")
                if httpResponse.statusCode == 403 &&  !(viewController==nil){
                    DispatchQueue.main.async{
                        viewController?.showError()
                    }
                }
            }
            
            guard let data = data else {
                print(String(describing: error))
                return
            }
            do{
                //print(data)
                //here data received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    data, options: [])
                
                //print(jsonResponse) //Response result
                guard let jsonArray = jsonResponse as? [[String: Any]] else {
                    return
                }
                //print(jsonArray)
                //iterate over JSON, adding each to location
                for dic in jsonArray{
                    
                    guard let jwtToken = dic["token"] else {
                        fatalError("Unable to instantiate seller")
                    }
                    self.token = jwtToken as? String
                    if !(viewController==nil){
                        DispatchQueue.main.async{
                            if !(self.token?.isEmpty ?? false){
                                viewController?.tokenUpdated(user:self)
                            }
                        }
                    }
                }
                //reload the table with the new values
                //Response not in JSON format
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        //We have to call the task here because it's asynchronous
        task.resume()
    }
    func getInfo(){
        print("getting info!")
        let scheme = "http"
        let host = "35.194.58.92"
        let path = "/registereduser"
        let queryItem = URLQueryItem(name: "email", value: "eq.\(self.email)")
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        urlComponents.queryItems = [queryItem]

        guard let url = urlComponents.url else { return }
        var request = URLRequest(url: url,timeoutInterval: Double.infinity)
        // print(url)

        //specify type of request
        request.httpMethod = "GET"

        //authorization
        request.setValue("Bearer \(self.token!)", forHTTPHeaderField: "Authorization")
        
        //make request to addresss in parameter
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                print("status code \(httpResponse.statusCode)")
            }
            guard let data = data else {
                print(String(describing: error))
                return
            }
            do{
                //print(data)
                
                //here data received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    data, options: [])
                
                //print(jsonResponse) //Response result
                guard let jsonArray = jsonResponse as? [[String: Any]] else {
                    return
                }
                print(jsonArray)
                //iterate over JSON, adding each to location
                for dic in jsonArray{
                  
                    guard let name = dic["name"] else {
                        fatalError("no name in json")
                    }
                    
                    self.name = name as? String
                    guard let venmo = dic["venmo"] else {
                        fatalError("no venmo in json")
                    }
                    
                    self.venmo = venmo as? String
                    
                    guard let uid = dic["uid"] else {
                        fatalError("no uid in json")
                    }
                    self.uid = uid as? Int
                    
                    let major = dic["major"] as? String
            
                    self.major = major
                    
                    let dorm = dic["dorm"] as? String
                    
                    self.dorm = dorm
                    
                }
                //reload the table with the new values
                //Response not in JSON format
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        //We have to call the task here because it's asynchronous
        task.resume()
    }
    
    func createPurchase(seller: Seller, price: Double, description: String, viewController: SubmitFooterViewController?){
        print("Inserting into purchase table!", self.uid)
        let parameters = "{  \"saleid\": \(seller.saleid), \"bid\": \(self.uid!), \"price\": \(price), \"approve\": false, \"paid\": false, \"p_description\": \"\(description)\"}"
        print(parameters)
        let postData = parameters.data(using: .utf8)
        var request = URLRequest(url: URL(string: "http://35.194.58.92/purchase")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        request.httpBody = postData
        
        //authorization
        request.setValue("Bearer \(self.token!)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
 
            if let httpResponse = response as? HTTPURLResponse 
                print("status code \(httpResponse.statusCode)")
                if httpResponse.statusCode == 201 {
                    let locationHeader = httpResponse.allHeaderFields["Location"] as! String
                    let pid = locationHeader.components(separatedBy: ".")[1]
                    print("pid, \(pid)")
                    viewController?.handleSuccessfulInsert(pid:Int(pid)!)
                }
                else{
                    print("Did not get 201 code, row not inserted")
                }
            }
            guard let data = data else {
                print(String(describing: error))
                return
            }
            print(String(data: data, encoding: .utf8)!)
            
        }
        
        task.resume()
    }
        
}


