//
//  SubmitSellLocationViewController.swift
//  Duke Shares Lunch
//
//  Created by Chris Theodore on 11/27/19.
//  Copyright © 2019 July Guys. All rights reserved.
//

import UIKit

class SubmitSellLocationViewController: UIViewController {
    
    var user:User?
    
    @IBOutlet weak var allOfWUSwitch: UISwitch!
    var selectedLocations = [String]()
    
    @IBAction func submitAction(_ sender: Any) {
        //call segue to rate/time pickers here
        
        // self.performSegue(withIdentifier: "pickerSegue", sender: self)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user?.getUserSales(viewcontroller: self)

        // Do any additional setup after loading the view.
    }
    private func loadWU()-> [String]{
        var locations = [String]()
        if let path = Bundle.main.path(forResource: "restaurants", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                // print(jsonResult)
                guard let jsonArray = jsonResult as? [[String: Any]] else {
                    return []
                }
                for dic in jsonArray{
                    guard let westunion = dic["West Union"] as? [[String:Any]] else { return [] }
                    for place in westunion{
                        locations += [place["name"] as! String]
                    }
                    
                }
            } catch {
                print("Unable to read json with the meals")
                return []
            }
        }
        return locations
    }
    

    func handleSuccessfulGetSales(){
        if !(user?.activeSales?.isEmpty ?? true){
            self.performSegue(withIdentifier: "hasActiveSalesSegue", sender: self)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let destinationController = segue.destination as? SalePickerViewController {
            
            if allOfWUSwitch.isOn{
                
                destinationController.locations = loadWU()
            } else{ destinationController.locations = selectedLocations }
            destinationController.user = user
            
        }
        if let destinationController = segue.destination as? MySalesViewController {
            destinationController.user = user
            
        }
        
    }

}
