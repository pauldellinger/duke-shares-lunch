//
//  ReportViewController.swift
//  FoodPointer
//
//  Created by Paul Dellinger on 1/4/20.
//  Copyright © 2020 July Guys. All rights reserved.
//

import UIKit

class ReportViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet var detailField: UITextView!
    var selected: Int?
    var user: User?
    
    
    @IBAction func submitAction(_ sender: Any) {
        print("submitting report")
        if passRegex(self.detailField.text){
            let details = detailField.text
            print(details)
            let hid = self.selected
            self.user?.createReport(note: details!, hid: hid, completion:{ error in
                if let error = error{
                    print("create report error: ", error)
                    return
                }
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            })
        } else {print("there's something wrong with your details field")}
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.detailField.delegate = self
        self.detailField.text = "Please give details on your problem"
        self.detailField.textColor = UIColor.lightGray
        let tap = UITapGestureRecognizer(target:self.view, action: #selector(self.detailField.endEditing))
        view.addGestureRecognizer(tap)
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
            textView.textColor = UIColor.lightGray
            textView.text = "Please give details on your problem"
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
