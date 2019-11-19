//
//  Duke_Shares_LunchTests.swift
//  Duke Shares LunchTests
//
//  Created by Chris Theodore on 11/12/19.
//  Copyright © 2019 July Boys. All rights reserved.
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
        exampleUser!.createUser()
        sleep(1)
        exampleUser?.login()
        sleep(1)
        XCTAssertNotNil(exampleUser?.token)
    }
    func testUserLoginSucceeds() {
        let exampleUser = User.init(email: "foo@bar.com", password: "foobar")
        exampleUser!.login()
        sleep(1)
        print(exampleUser?.token)
        XCTAssertNotNil(exampleUser?.token)
        
        
    }

}
