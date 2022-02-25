//
//  PaymentSuccessAndFailViewController.swift
//  Actorpay
//
//  Created by iMac on 09/02/22.
//

import UIKit
import Lottie

class PaymentSuccessAndFailViewController: UIViewController {
    
    //MARK: - Properties -
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var walletHistoryBtn: UIView!
    @IBOutlet weak var transactionIdLbl: UILabel!
    @IBOutlet weak var doneButtonView: UIView!
    @IBOutlet weak var buttonStackView: UIStackView!
    
    var isSuccess = false
    var addMoneyWalletAmount = ""
    var isAddMoneyWallet = false
    var transactionDetails: TransactionDetails?
    
    //MARK: - Life Cycles -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        topCorner(bgView: bgView, maskToBounds: true)
        self.setUpUI()
    }
    
    //MARK: - Selectors -
    
    // Back Button Action
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    // Wallet History Button Action
    @IBAction func walletHistoryBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if let myOrderVC = storyboard?.instantiateViewController(withIdentifier: "WalletStatementViewController") {
            let contentViewController = UINavigationController(rootViewController: myOrderVC)
            sideMenuViewController?.setContentViewController(contentViewController, animated: true)
            sideMenuViewController?.hideMenuViewController()
        }
    }
    
    // Done Button Action
    @IBAction func doneButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    //MARK: - Helper Functions -
    
    // SetUp UI
    func setUpUI() {
        self.descLabel.text = isAddMoneyWallet ? "Amount ₹\(transactionDetails?.transferredAmount ?? 0.0) \n added into wallet successfully" : "Amount ₹\(addMoneyWalletAmount) transferred into \(transactionDetails?.customerName ?? "")'s wallet successfully"
        self.transactionIdLbl.text = "Transaction ID: \(transactionDetails?.transactionId ?? "")"
        self.titleLabel.text = isSuccess ? "Payment Succeed!" : "Payment Failed"
        self.buttonStackView.isHidden = isSuccess ? false : true
        animationView.animation = Animation.named(isSuccess ? "success_tick_lottie" : "fail_tick_lottie")
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce
        animationView.animationSpeed = 0.5
        animationView.play()
    }

}
