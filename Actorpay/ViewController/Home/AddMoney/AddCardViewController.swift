//
//  AddCardViewController.swift
//  Actorpay
//
//  Created by iMac on 03/12/21.
//

import UIKit

class AddCardViewController: UIViewController {

    //MARK:- Properties -
    
    @IBOutlet weak var cardHolderNameTextField: UITextField!
    @IBOutlet weak var cardNumberTextField: UITextField!
    @IBOutlet weak var cardExpiryDateTextField: UITextField!
    @IBOutlet weak var cardCVVNumberTextField: UITextField!
    @IBOutlet weak var mainView: UIView!

    var isSavedCard = false
    
    //MARK:- Life Cycle Function -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        topCorner(bgView: mainView, maskToBounds: true)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    //MARK:- Selectors -
    
    // Back Button Action
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    // Save Card Check Box Button Action
    @IBAction func saveCardCheckBocAction(_ sender: UIButton) {
        self.view.endEditing(true)
        isSavedCard = !isSavedCard
        if #available(iOS 13.0, *) {
            sender.setImage(UIImage(systemName: isSavedCard ? "checkmark" : ""), for: .normal)
            sender.tintColor = isSavedCard ? .white : .systemGray5
            sender.backgroundColor = isSavedCard ? UIColor(named: "BlueColor") : .none
            sender.borderColor = isSavedCard ? UIColor(named: "BlueColor") : .systemGray5
        }
    }
    
    // Pay Now Button Action
    @IBAction func payNowButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if cardHolderNameTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            self.alertViewController(message: "Please enter Card holder Name.")
            return
        }
        if cardNumberTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            self.alertViewController(message: "Please enter a card number.")
            return
        }
        if cardExpiryDateTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            self.alertViewController(message: "Please enter an expiry date.")
            return
        }
        if cardCVVNumberTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            self.alertViewController(message: "Please enter a CVV Code.")
            return
        }
        //Pay Now Button Action
        let newVC = self.storyboard?.instantiateViewController(withIdentifier: "PaymentSuccessAndFailViewController") as! PaymentSuccessAndFailViewController
        newVC.isSuccess = true
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    
    //MARK:- Helper Function -
    
}
