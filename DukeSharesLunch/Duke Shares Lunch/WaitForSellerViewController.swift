//
//  WaitForSellerViewController.swift
//  Duke Shares Lunch
//
//  Created by Chris Theodore on 11/30/19.
//  Copyright © 2019 July Guys. All rights reserved.
//

import UIKit

class WaitForSellerViewController: UIViewController {
    
    var seller: Seller?
    var user: User?
    var purchase: Int?
    var cost: Double?
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var waitingSpinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.refreshControl = UIRefreshControl()
        scrollView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl),for: .valueChanged)
    }
    
    @objc func handleRefreshControl() {
        print("refreshing!")
        user?.checkPurchase(pid: purchase!, viewController: self)
    }
    func handleApproval(approved: Bool){
        scrollView.refreshControl?.endRefreshing()
        if approved {
                 performSegue(withIdentifier: "venmoPageSegue", sender: self)
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let nextController = segue.destination as? VenmoSellerViewController{
            nextController.user = user
            nextController.seller = seller
            nextController.cost = cost
            
        }
    }
    

}
