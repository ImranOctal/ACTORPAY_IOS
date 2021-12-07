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
        // Main View design
        topCorner(bgView: mainView, maskToBounds: true)
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    //MARK:- Selectors -
    
    @IBAction func saveCardCheckBocAction(_ sender: UIButton) {
        self.view.endEditing(true)
        // remember Me
        isSavedCard = !isSavedCard
        if #available(iOS 13.0, *) {
            sender.setImage(UIImage(systemName: isSavedCard ? "checkmark" : ""), for: .normal)
            sender.tintColor = isSavedCard ? .white : .systemGray5
            sender.backgroundColor = isSavedCard ? UIColor(named: "BlueColor") : .none
            sender.borderColor = isSavedCard ? UIColor(named: "BlueColor") : .systemGray5
        }
    }
    
    @IBAction func payNowButtonAction(_ sender: UIButton){
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
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PaymentSucceedViewController") as! PaymentSucceedViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- Helper Function -
    
}
