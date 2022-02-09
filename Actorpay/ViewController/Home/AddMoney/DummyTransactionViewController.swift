//
//  DummyTransactionViewController.swift
//  Actorpay
//
//  Created by iMac on 09/02/22.
//

import UIKit

class DummyTransactionViewController: UIViewController {
    
    //MARK: - Properties -
    
    @IBOutlet weak var bgView: UIView!
    
    //MARK: - Life Cycles -

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        topCorner(bgView: bgView, maskToBounds: true)
    }
    
    //MARK: - Selectors -
    
    // Back Button Action
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    // Success Button Action
    @IBAction func successBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let newVC = self.storyboard?.instantiateViewController(withIdentifier: "PaymentSuccessAndFailViewController") as! PaymentSuccessAndFailViewController
        newVC.isSuccess = true
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    
    // Fail Button Aciton
    @IBAction func failButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let newVC = self.storyboard?.instantiateViewController(withIdentifier: "PaymentSuccessAndFailViewController") as! PaymentSuccessAndFailViewController
        newVC.isSuccess = false
        self.navigationController?.pushViewController(newVC, animated: true)
    }

}
