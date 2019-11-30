//
//  MySalesViewController.swift
//  Duke Shares Lunch
//
//  Created by Chris Theodore on 11/28/19.
//  Copyright © 2019 July Guys. All rights reserved.
//

import UIKit

class MySalesViewController: UIViewController {
    var user: User?
    @IBAction func moreLocationsAction(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let detailViewController = segue.destination as? ActiveSalesTableViewController
//        detailViewController?.seller = seller
        detailViewController?.user = user

    }
    

}
