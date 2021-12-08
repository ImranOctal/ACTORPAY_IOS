//
//  QRCodePayNowViewController.swift
//  Actorpay
//
//  Created by iMac on 08/12/21.
//

import UIKit

class QRCodePayNowViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var reasonTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topCorner(bgView: mainView, maskToBounds: true)
        reasonTextView.delegate = self
        reasonTextView.text = "Enter Reason"
        reasonTextView.textColor = UIColor.lightGray
        // Do any additional setup after loading the view.
    }

    @IBAction func backButtonAction(_ sender: UIButton){
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func payNowButtonAction(_ sender: UIButton){
        self.view.endEditing(true)
        if amountTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            self.alertViewController(message: "Please enter an amount.")
            return
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Placeholder"
            textView.textColor = UIColor.lightGray
        }
    }
    
}
