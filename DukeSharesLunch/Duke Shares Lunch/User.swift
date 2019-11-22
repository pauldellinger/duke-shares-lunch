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
    
    //commit test
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
        
    func login(){
        
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
        
}


