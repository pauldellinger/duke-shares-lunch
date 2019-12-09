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
    @IBAction func cancelOrderAction(_ sender: Any) {
        user?.removePurchase(pid: purchase!, viewController: self)
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var waitingSpinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        scrollView.refreshControl = UIRefreshControl()
        scrollView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl),for: .valueChanged)
    }
    override func viewDidDisappear(_ animated: Bool) {
        print("wait for seller disappeared")
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
    
    func handleCancellation(){
        print("back to the main tab!")
        //go back to root view controller.
        navigationController?.popToRootViewController(animated: true)
    }
    func handleDeletion(){
        let alert = UIAlertController(title: "Purchase Declined", message: "Sorry, please try again", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
              switch action.style{
              case .default:
                self.navigationController?.popToRootViewController(animated: true)

              case .cancel:
                    print("cancel")

              case .destructive:
                    print("destructive")


        }}))
        self.present(alert, animated: true, completion: nil)
        //navigationController?.popToRootViewController(animated: true)
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
