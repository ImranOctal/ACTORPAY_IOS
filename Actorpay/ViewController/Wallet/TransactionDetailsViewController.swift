//
//  TransactionDetailsViewController.swift
//  Actorpay
//
//  Created by iMac on 24/02/22.
//

import UIKit

class TransactionDetailsViewController: UIViewController {
    
    //MARK: - Properties -
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var transactionIdLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var transferAmountLbl: UILabel!
    @IBOutlet weak var adminCommissionLbl: UILabel!
    @IBOutlet weak var totalAmountLbl: UILabel!
    @IBOutlet weak var transactionDetailView: UIView!
    @IBOutlet weak var toUserNameLbl: UILabel!
    @IBOutlet weak var toUserView: UIView!
    
    var walletItems: WalletItems?
    
    //MARK: - Life Cycles -

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        topCorner(bgView: bgView, maskToBounds: true)
        self.setWalletTransactionData()
    }
    
    //MARK:- Selectors -
    
    // Back Button Action
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    // Done Button Action
    @IBAction func doneButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Helper Functions -
 
    // Set Wallet Transaction Data
    func setWalletTransactionData() {
        titleLbl.text = purchaseType(purchaseType: walletItems?.purchaseType ?? "")
        transactionIdLbl.text = walletItems?.walletTransactionId
        dateLbl.text = walletItems?.createdAt?.toFormatedDate(from: "yyyy-MM-dd HH:mm", to: "dd MMM yyyy HH:MM")
        amountLbl.text = "₹ \(walletItems?.transactionAmount ?? 0.0)"
        transferAmountLbl.text = "₹ \(walletItems?.transferAmount ?? 0.0)"
        adminCommissionLbl.text = "₹ \(walletItems?.adminCommission ?? 0.0)"
        totalAmountLbl.text = "₹ \(walletItems?.transactionAmount ?? 0.0)"
        amountLbl.textColor = transactionType(transactionType: walletItems?.transactionTypes ?? "")
        toUserNameLbl.text = (walletItems?.toUserName ?? "").replacingOccurrences(of: ",", with: "")
        toUserView.isHidden = walletItems?.purchaseType == "TRANSFER" ? false : true
        
    }

}
