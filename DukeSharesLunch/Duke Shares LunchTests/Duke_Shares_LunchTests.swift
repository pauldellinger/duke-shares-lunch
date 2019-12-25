//
//  Duke_Shares_LunchTests.swift
//  Duke Shares LunchTests
//
//  Created by Paul Dellinger on 11/12/19.
//  Copyright © 2019 July Guys. All rights reserved.
//

import XCTest
@testable import Duke_Shares_Lunch


class Duke_Shares_LunchTests: XCTestCase {

//    override func setUp() {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//    }
//
//    override func tearDown() {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//    }
//
//    func testExample() {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//    }
//
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
    //MARK: Meal Class Tests
    
    // Confirm that the Meal initializer returns a Meal object when passed valid parameters.
    func testLocationInitializationSucceeds() {
        // Empty String
        let emptyStringLocation = Location.init(name: "", count: 0)
        XCTAssertNil(emptyStringLocation)
        
        let negativeCountLocation = Location.init(name: "negative", count: -1)
        XCTAssertNil(negativeCountLocation)
        
        
    }
    //MARK: User Class Tests
    
    // Confirm that the User initializer returns a User object when passed valid parameters.
    func testUserInitializationSucceeds() {
        // Empty String
        let emptyEmailUser = User.init(email: "", password: "foobar")
        XCTAssertNil(emptyEmailUser)
        
        let empytPasswordUser = User.init(email: "foo@bar.com", password: "")
        XCTAssertNil(empytPasswordUser)
        
    }
    func testUserCreation(){
        let randy = Int.random(in: 1000..<9000)
        let exampleUser = User.init(email: "foo\(randy)@bar.com", password: "foobar")
        exampleUser!.createUser(viewController:nil)
        sleep(1)
        exampleUser?.login(viewController: nil)
        sleep(1)
        XCTAssertNotNil(exampleUser?.token)
    }
    func testUserLoginSucceeds() {
        let exampleUser = User.init(email: "pd88@duke.edu", password: "Password1")
        exampleUser!.login(viewController: nil)
        sleep(1)
        print(exampleUser?.token)
        XCTAssertNotNil(exampleUser?.token)
    }
    func testUserLoginFails() {
        let exampleUser = User.init(email: "foo@bar.com", password: "incorrectpassword")
        exampleUser!.login(viewController: nil)
        sleep(1)
        XCTAssertNil(exampleUser?.token)
    }
    func testUserGetInfo() {
        let exampleUser = User.init(email: "pd88@duke.edu", password: "Password1")
        exampleUser!.login(viewController: nil)
        sleep(1)
        print(exampleUser?.token)
        exampleUser?.getInfo(viewController: nil)
        sleep(1)
        print(exampleUser?.name)
        XCTAssertNotNil(exampleUser?.name)
    }
//    func testUserGetInfo2(){
//        
//        let exampleUser = User.init(email: "pd88@duke.edu", password: "Password1")
//    }
    func testloadMeals() {
        if let path = Bundle.main.path(forResource: "restaurants", ofType: "json") {
            do {
                  let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                  let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                    // print(jsonResult)
                guard let jsonArray = jsonResult as? [[String: Any]] else {
                    return
                }
                for dic in jsonArray{
                    guard let westunion = dic["West Union"] as? [[String:Any]] else {return}
                    for restaurant in westunion{
                        if (restaurant["name"] as! String? == "Il Forno"){
                            guard let menu = restaurant["menu"] as? [[String:Any]] else { return }
                            for item in menu {
                                print(item["name"], item["price"])
                            }
                        }
                    }
                    
                }
            
              } catch {
                print("Unable to read json with the meals")
                return
              }
        }
        
    }
    func testCreatePurchase() {
        let exampleUser = User.init(email: "pd88@duke.edu", password: "Password1")
        exampleUser!.login(viewController: nil)
        sleep(1)
        print(exampleUser?.token)
        exampleUser?.getInfo(viewController: nil)
        sleep(1)
        let exampleSeller = Seller.init(saleid: 5, sellerId: 2, status: true, locationName: "Il Forno", sellerName : "Josh Romine", sellerVenmo: "Joshie likes cash", rate: 0.6, ordertime: "Right now ahaha")
        print(exampleSeller)

        exampleUser?.createPurchase(seller: exampleSeller!, price: 10.00, description: "one pasta bowl2", viewController:nil)
        sleep(3)
        
    }
    func testGenPostBody(){
        
        let exampleUser = User.init(email: "pd88@duke.edu", password: "Password1")
        exampleUser!.login(viewController: nil)
        sleep(1)
        print(exampleUser?.token)
        exampleUser?.getInfo(viewController: nil)
        sleep(1)
        let locations = ["Il Forno", "Ginger and Soy"]
        let ordertime = 5
        let rate = 0.90
        let JSON = exampleUser?.genPostBody(locations:locations, ordertime:ordertime, rate: rate)
        if let JSON = JSON {
            print(String(data: JSON, encoding: String.Encoding.utf8))
        }
    }
    func testGetPurchases(){
        let exampleUser = User.init(email: "pd88@duke.edu", password: "Password1")
        exampleUser!.login(viewController: nil)
        sleep(1)
        print(exampleUser?.token)
        exampleUser?.getInfo(viewController: nil)
        sleep(1)
        print(exampleUser?.uid)
        exampleUser?.getUserSales(viewcontroller: nil)
        sleep(1)
        exampleUser?.getPurchases(viewController: nil)
        sleep(1)
        
    }
    func testTimeUntilOrder(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-ddHH:mm:ss"
        var date = formatter.string(from: Date().addingTimeInterval(300))
        print(date)
        let vc = LocationDetailTableViewController()
        XCTAssert(5 == vc.timeUntilOrder(ordertime:date))
        date = formatter.string(from: Date().addingTimeInterval(-300))
        XCTAssert(-5 == vc.timeUntilOrder(ordertime:date))
        date = formatter.string(from: Date().addingTimeInterval(0))
        XCTAssert(0 == vc.timeUntilOrder(ordertime:date))

    }

}
