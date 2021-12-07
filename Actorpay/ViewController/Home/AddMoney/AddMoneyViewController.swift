//
//  AddMoneyViewController.swift
//  Actorpay
//
//  Created by iMac on 03/12/21.
//

import UIKit

class AddMoneyViewController: UIViewController {

    //MARK:- Properties -
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var selectCardView: UIView!
    @IBOutlet weak var amountTextField: UITextField!
    
    //MARK:- Life Cycle Function -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topCorner(bgView: mainView, maskToBounds: true)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    //MARK:- Selectors -
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func creditOrDebitCardButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
    }
    
    @IBAction func netBankingButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
    }
    
    @IBAction func addMoneyButtonAction(_ sender: UIButton){
        self.view.endEditing(true)
        if amountTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            self.alertViewController(message: "Please enter an amount.")
            return
        }
        //Pay Now Button Action
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddCardViewController") as! AddCardViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    //MARK:- Helper Functions -
}
