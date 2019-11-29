//
//  SalePickerViewController.swift
//  Duke Shares Lunch
//
//  Created by Chris Theodore on 11/28/19.
//  Copyright © 2019 July Guys. All rights reserved.
//

import UIKit

class SalePickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var locations: [String]?
    var user: User?
   
    @IBOutlet weak var noTimeSwitch: UISwitch!
    
    @IBAction func submitSellerAction(_ sender: Any) {
        //insert into active sellers
        //if successful segue
        var ordertime = Int()
        if !noTimeSwitch.isOn{
            ordertime = timePickerData[timePicker.selectedRow(inComponent: 0)]
        }
        
        let rate = Double(ratePickerData[ratePicker.selectedRow(inComponent: 0)])
        
        print(locations, ordertime, rate)
            user?.createSales(locations: locations, ordertime: ordertime, rate:rate, viewController:self)
    }
    
    
    @IBOutlet weak var ratePicker: UIPickerView!
    @IBOutlet weak var timePicker: UIPickerView!
    
    
    
    let ratePickerData = Array(stride(from: 99, through: 0, by: -1))
    let timePickerData = Array(stride(from: 0, through: 59, by: 1))
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ratePicker.delegate = self
        self.ratePicker.dataSource = self
        self.timePicker.delegate = self
        self.timePicker.dataSource = self

        print(String(format: "%.2f", timePickerData[4]))
        
        // Input the data into the array
        
        // Do any additional setup after loading the view.
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
           return 1
       }
       
       func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
           if pickerView == timePicker {
            return 60
           } else {
               return 100
           }
       }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == ratePicker {
            return "\(ratePickerData[row])%"
        } else {
            return "\(timePickerData[row]) minutes"
        }
    }
    

    func handleSuccessfulInsert(){
        //call segue here
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        guard let nextController = segue.destination as? MySalesViewController
            else {
                return
        }
        nextController.user = user
    }
    

}