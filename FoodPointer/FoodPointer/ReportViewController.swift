//
//  ReportViewController.swift
//  FoodPointer
//
//  Created by Paul Dellinger on 1/4/20.
//  Copyright © 2020 July Guys. All rights reserved.
//

import UIKit

class ReportViewController: UIViewController {
    @IBOutlet var detailField: UITextView!
    var selected: Purchase?
    var user: User?
    
    
    @IBAction func submitAction(_ sender: Any) {
        print("submitting report")
        if passRegex(self.detailField.text){
            let details = detailField.text
            print(details)
            let pid = self.selected?.pid
        } else {print("there's something wrong with your details field")}
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.detailField.text = "Please give details on your problem"
        self.detailField.textColor = UIColor.lightGray
        
        // Do any additional setup after loading the view.
    }
    //mimic placeholder
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Please give details on your problem"
            textView.textColor = UIColor.lightGray
        }
    }
    func passRegex(_: String)->Bool{
        return true
    }
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let detailViewController = segue.destination as? HistoryTableViewController{
            detailViewController.user = self.user
        }
    }

    

}
