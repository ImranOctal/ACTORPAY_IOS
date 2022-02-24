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
    
    var isSuccess = false
    var addMoneyWalletAmount = ""
    var isAddMoneyWallet = false
    
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
    
    //MARK: - Helper Functions -
    
    // SetUp UI
    func setUpUI() {
        if isSuccess {
            self.descLabel.isHidden = false
            descLabel.text = isAddMoneyWallet ? "Amount ₹\(addMoneyWalletAmount).0 \n has been added successfully" : "Transaction has been done successfully"
            self.titleLabel.text = "Payment Succeed!"
            self.walletHistoryBtn.isHidden = isAddMoneyWallet ? false : true
            animationView.animation = Animation.named("success_tick_lottie")
            animationView.contentMode = .scaleAspectFit
            animationView.loopMode = .playOnce
            animationView.animationSpeed = 0.5
            animationView.play()
        } else {
            self.descLabel.isHidden = true
            self.titleLabel.text = "Payment Failed"
            self.walletHistoryBtn.isHidden = true
            animationView.animation = Animation.named("fail_tick_lottie")
            animationView.contentMode = .scaleAspectFit
            animationView.loopMode = .playOnce
            animationView.animationSpeed = 0.5
            animationView.play()
        }
    }

}
