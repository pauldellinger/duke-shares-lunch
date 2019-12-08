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
    var password: String?
    var email: String?
    var token: String?
    var venmo: String?
    var major: String?
    var dorm: String?
    var activeSales:[Seller]?
    
    init? (email:String, password:String ){
        
        self.email = email
        self.password = password
        if email.isEmpty || password.isEmpty {
            return nil
        }
    }
    init? (name: String, venmo:String){
        self.name = name
        self.venmo = venmo
        if name.isEmpty || venmo.isEmpty {
            return nil
        }
    }
    init? (name:String, email:String, password: String,venmo: String, major:String?, dorm:String?){
        self.email = email
        self.password = password
        self.name = name
        self.venmo = venmo
        self.major = major ?? ""
        self.dorm = dorm ?? ""
    }
    
        
    func createUser(viewController: CreateProfileViewController?){
        var parameters : String
        if self.dorm!.isEmpty || self.major!.isEmpty{
            // don't send empty dorm and major, default is null
            parameters = "{ \"email\": \"\(self.email!)\", \"pass\": \"\(self.password!)\", \"venmo\": \"\(self.venmo!)\", \"name\": \"\(self.name!)\" }"
        } else{
            parameters = "{ \"email\": \"\(self.email!)\", \"pass\": \"\(self.password!)\", \"venmo\": \"\(self.venmo!)\", \"name\": \"\(self.name!)\", \"major\": \"\(self.major ?? "")\", \"dorm\": \"\(self.dorm ?? "")\" }"
        }
        let postData = parameters.data(using: .utf8)
        var request = URLRequest(url: URL(string: "http://35.193.85.182/rpc/make_user")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        request.httpBody = postData
        //make request to addresss in parameter
        //This token will work for everyone  - need a way to generate and have them expire after one use
        request.setValue("Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidG9kb191c2VyIn0.IWnJCBgXAYfPGA-zB4JPlcAGfDYkwTwCTmQM-boguV8", forHTTPHeaderField: "Authorization")
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
                                self.login(viewController:viewController)
                        } else{
                            print("User Creation Unsuccessul")
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
        
    func login(viewController: Any?){
        let email = self.email!
        let password = self.password!
        let parameters = "{ \"email\": \"\(email)\", \"pass\": \"\(password)\" }"
    
        let postData = parameters.data(using: .utf8)
        var request = URLRequest(url: URL(string: "http://35.193.85.182/rpc/login")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        request.httpBody = postData
        //make request to addresss in parameter
        
        //specify type of request
        request.httpMethod = "POST"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                print("status code \(httpResponse.statusCode)")
                if httpResponse.statusCode != 403 &&  !(viewController==nil){
                    DispatchQueue.main.async{
                        if let viewController = viewController as? UserPageViewController{
                            viewController.showError()
                        }
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
                                let defaults = UserDefaults.standard
                                defaults.set(email, forKey: "email")
                                defaults.set(password, forKey: "password")
                                defaults.set(self.token, forKey: "token")
                                if let viewController = viewController as? UserPageViewController{
                                    viewController.tokenUpdated(user:self)
                                }
                                if let viewController = viewController as? CreateProfileViewController{
                                    // print(self.token, "giving the token to creatprofileviewcontroller")
                                    viewController.handleSuccessfulCreate()
                                }
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
    
    func getInfo(viewController:TabController?){
        print("getting info!")
        let scheme = "http"
        let host = "35.193.85.182"
        let path = "/registereduser"
        let queryItem = URLQueryItem(name: "email", value: "eq.\(self.email!)")
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
                    if let viewController = viewController{
                        DispatchQueue.main.async{
                            viewController.handleInfo()
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
    
    func createPurchase(seller: Seller, price: Double, description: String, viewController: SubmitFooterViewController?){
        print("Inserting into purchase table!", self.uid)
        let parameters = "{  \"saleid\": \(seller.saleid), \"bid\": \(self.uid!), \"price\": \(price), \"approve\": false, \"paid\": false, \"p_description\": \"\(description)\"}"
        print(parameters)
        let postData = parameters.data(using: .utf8)
        var request = URLRequest(url: URL(string: "http://35.193.85.182/purchase")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        request.httpBody = postData
        
        //authorization
        request.setValue("Bearer \(self.token!)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let httpResponse = response as? HTTPURLResponse {
                
                print("status code \(httpResponse.statusCode)")
                if httpResponse.statusCode == 201 {
                    let locationHeader = httpResponse.allHeaderFields["Location"] as! String
                    let pid = locationHeader.components(separatedBy: ".")[1]
                    print("pid, \(pid)")
                    DispatchQueue.main.async{
                        viewController?.handleSuccessfulInsert(pid:Int(pid)!)
                    }
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
    
    func createSales(locations: [String]?, ordertime:Int, rate:Double, viewController: SalePickerViewController){
        // TODO: http://postgrest.org/en/v6.0/api.html#upsert
        //let parameters = "{  \"saleid\": \(seller.saleid), \"bid\": \(self.uid!), \"price\": \(price), \"approve\": false, \"paid\": false, \"p_description\": \"\(description)\"}"
        // print(parameters)
        // postBody = genPostBody(locations)
        
        let postData = genPostBody(locations: locations ?? [], ordertime: ordertime, rate:rate)
        var request = URLRequest(url: URL(string: "http://35.193.85.182/activeseller")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("resolution=merge-duplicates", forHTTPHeaderField: "Prefer")
        
        request.httpMethod = "POST"
        request.httpBody = postData
        
        //authorization
        request.setValue("Bearer \(self.token!)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let httpResponse = response as? HTTPURLResponse {
                
                print("status code \(httpResponse.statusCode)")
                if httpResponse.statusCode == 201 {
                    print("Successfully inserted sales!")
                    DispatchQueue.main.async{
                        viewController.handleSuccessfulInsert()
                    }
                    
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
    func genPostBody(locations:[String], ordertime:Int, rate: Double) -> Data{
        var sales = [[String:Any]]()
        for location in locations{
            print(location)
            var sale = [String:Any]()
            sale["uid"] = self.uid
            
            let date = Date().addingTimeInterval(Double(ordertime) * 60.0)
            //print(stringFromDate(date))
            sale["ordertime"] = stringFromDate(date)
            
            sale["status"] = true
            sale["percent"] = String(format: "%.2f", rate)
            sale["location"] = location
            sales.append(sale)
        }
        let JSON = try? JSONSerialization.data(withJSONObject: sales, options: [])
        print(sales)
        return JSON!
    }
    private func stringFromDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: date)
    }
    
    func getUserSales(viewcontroller: Any?){
        print("getting active sales!")
        let scheme = "http"
        let host = "35.193.85.182"
        let path = "/activeseller"
        let queryItem = URLQueryItem(name: "select", value: "saleid,uid,seller:registereduser(name,venmo),ordertime,status,percent,location")
        let uidEquality = "eq.\(self.uid!)"
        let queryItem2 = URLQueryItem(name: "uid", value: uidEquality)
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        urlComponents.queryItems = [queryItem]
        urlComponents.queryItems! += [queryItem2]
        
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
                if httpResponse.statusCode == 200 {
                    print("Got the Active Sales!")
                }
                else{
                    print("Did not get 200 code, something went wrong")
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
                print(jsonArray)
                //iterate over JSON, adding each to location
//                var sales = [Seller]()
                self.activeSales = [Seller]()
                for dic in jsonArray{
                    guard let sale = Seller(json:dic) else {
                        fatalError("Unable to instantiate seller")
                    }
                    self.activeSales?.append(sale)
                    
                }
                DispatchQueue.main.async{
                    if let viewcontroller = viewcontroller as? ActiveSalesTableViewController{
                        viewcontroller.handleSuccessfulGetSales()
                    }
                    if let viewcontroller = viewcontroller as? SubmitSellLocationViewController{
                        viewcontroller.handleSuccessfulGetSales()
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
    
    func getPurchases(viewController: Any?){
        print("getting purchases!")
        let scheme = "http"
        let host = "35.193.85.182"
        let path = "/rpc/seller_purchases"
        let queryItem = URLQueryItem(name: "sellerid", value: String(self.uid!))
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        urlComponents.queryItems = [queryItem]

        guard let url = urlComponents.url else { return }
        var request = URLRequest(url: url,timeoutInterval: Double.infinity)
        print(url)
        
        //specify type of request
        request.httpMethod = "GET"
        
        //authorization
        request.setValue("Bearer \(self.token!)", forHTTPHeaderField: "Authorization")
        
        print(request)
        
        //make request to addresss in parameter
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            print("requesting!")
            if let httpResponse = response as? HTTPURLResponse {
                print("status code \(httpResponse.statusCode)")
                if httpResponse.statusCode == 200 {
                    print("Got the Purchases!")
                }
                else{
                    print("Did not get 200 code, something went wrong")
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
                print(jsonArray)
                //iterate over JSON, adding each to location
                //                var sales = [Seller]()
                
                // first element is array of unapproved, second is approved
                var purchases = [[Purchase](), [Purchase]()]
                for dic in jsonArray{
                    let pid = dic["pid"] as! Int
                    
                    var seller : Seller?
                    print(self.activeSales)
                    for sale in self.activeSales ?? [] {
                        print(sale.saleid)
                        if sale.saleid == dic["saleid"] as! Int{
                            seller = sale
                        }
                    }
                    
                    let buyer = User.init(name: dic["buyername"] as! String, venmo: dic["buyervenmo"] as! String)!
                    let price = dic["price"] as! Double
                    let approve = dic["approve"] as! Bool
                    let paid = dic["paid"] as! Bool
                    let description = dic["p_description"] as! String
                    print(pid, seller, buyer, price, approve, paid, description)
                    let purchase = Purchase.init(pid: pid, seller: seller!, buyer: buyer, price: price, approve: approve, paid: paid, description: description)!
                    
                    if purchase.approve { purchases[1].append(purchase)}
                    else {purchases[0].append(purchase)}
                    
                }
                //print(purchases[0].seller.locationName)
                
                DispatchQueue.main.async{
                    if let viewController = viewController as? ActiveSalesTableViewController{
                        viewController.handleSuccessfulGetPurchase(purchases:purchases)
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
    func checkPurchase(pid:Int, viewController: WaitForSellerViewController?){
        print("looking for purchase!")
        let scheme = "http"
        let host = "35.193.85.182"
        let path = "/purchase"
        let queryItem = URLQueryItem(name: "pid", value: "eq.\(pid)")
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        urlComponents.queryItems = [queryItem]

        guard let url = urlComponents.url else { return }
        var request = URLRequest(url: url,timeoutInterval: Double.infinity)
        print(url)
        
        //specify type of request
        request.httpMethod = "GET"
        
        //authorization
        request.setValue("Bearer \(self.token!)", forHTTPHeaderField: "Authorization")
        
        print(request)
        
        //make request to addresss in parameter
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            print("requesting!")
            if let httpResponse = response as? HTTPURLResponse {
                print("status code \(httpResponse.statusCode)")
                if httpResponse.statusCode == 200 {
                    print("Got the Purchase!")
                }
                else{
                    print("Did not get 200 code, something went wrong")
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
                print(jsonArray)
                //iterate over JSON, adding each to location
                //                var sales = [Seller]()
                for dic in jsonArray{
                    let approved = dic["approve"] as? Bool
                    
                        DispatchQueue.main.async{
                            if let viewController = viewController{
                                if approved ?? false{
                                    viewController.handleApproval(approved: true)
                                } else { viewController.handleApproval(approved: false) }
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
    func removePurchase(pid: Int, viewController: WaitForSellerViewController?){
        print("Removing purchase!")
        let scheme = "http"
        let host = "35.193.85.182"
        let path = "/purchase"
        let queryItem = URLQueryItem(name: "pid", value: "eq.\(pid)")
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
        request.setValue("Bearer \(self.token!)", forHTTPHeaderField: "Authorization")
        
        print(request)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                print("status code \(httpResponse.statusCode)")
                if httpResponse.statusCode == 204 {
                    print("Purchase Deleted!")
                    if let viewController = viewController{
                        DispatchQueue.main.async{
                            viewController.handleCancellation()
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


