//
//  AddMoneyInWalletViewController.swift
//  Actorpay
//
//  Created by iMac on 09/02/22.
//

import UIKit
import Alamofire

class AddMoneyInWalletViewController: UIViewController {
    
    // MARK: - Properties -
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var addMoneyAmountCollectionView: UICollectionView! {
        didSet {
            self.addMoneyAmountCollectionView.delegate = self
            self.addMoneyAmountCollectionView.dataSource = self
        }
    }
    @IBOutlet weak var amountTextField: UITextField! {
        didSet {
            self.amountTextField.delegate = self
        }
    }
    @IBOutlet weak var amountValidationLbl: UILabel!
    @IBOutlet weak var walletBalanceLbl: UILabel!
    
    var addMoneyAmountArr = [50,100,200,500,1000,2000]
    var transactionDetails: TransactionDetails?

    //MARK: - Life Cycles -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        topCorner(bgView: bgView, maskToBounds: true)
        self.manageValidationLabel()
        NotificationCenter.default.removeObserver(self, name: Notification.Name("setWalletBalanceInAddMoneyInWallet"), object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(self.setWalletBalanceInAddMoneyInWallet),name:Notification.Name("setWalletBalanceInAddMoneyInWallet"), object: nil)
        self.setWalletBalanceInAddMoneyInWallet()
    }
    
    //MARK: - Selectors -
    
    // Back Button Action
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    // Add Money Button Action
    @IBAction func addMoneyBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if addMoneyInWalletValidation() {
            self.manageValidationLabel()
            self.addMoneyToWalletApi()
        }
    }
    
    //MARK: - Helper Functions -
    
    // Validation Label Manage
    func manageValidationLabel() {
        self.amountValidationLbl.isHidden = true
    }
    
    // Add Money In Wallet Validation
    func addMoneyInWalletValidation() -> Bool {
        var isValidate = true
        
        if amountTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            self.amountValidationLbl.isHidden = false
            self.amountValidationLbl.text = ValidationManager.shared.emptyAmount
            isValidate = false
        } else {
            self.amountValidationLbl.isHidden = true
        }
        
        return isValidate
    }
    
    // Set Wallet Balance
    @objc func setWalletBalanceInAddMoneyInWallet() {
        walletBalanceLbl.text = "₹ \(walletData?.amount ?? 0.0)"
    }
    
}

//MARK: - Extensions -

//MARK: Api Call
extension AddMoneyInWalletViewController {
    
    // Add Money In Wallet Api
    func addMoneyToWalletApi() {
        let bodyParameter: Parameters = [
            "amount": amountTextField.text ?? ""
        ]
        showLoading()
        APIHelper.addMoneyToWalletApi(bodyParameter: bodyParameter) { (success,response)  in
            if !success {
                dissmissLoader()
                let message = response.message
                myApp.window?.rootViewController?.view.makeToast(message)
            }else {
                dissmissLoader()
                let message = response.message
//                myApp.window?.rootViewController?.view.makeToast(message)
                print(message)
                let data = response.response["data"]
                self.transactionDetails = TransactionDetails.init(json: data)
                let newVC = self.storyboard?.instantiateViewController(withIdentifier: "PaymentSuccessAndFailViewController") as! PaymentSuccessAndFailViewController
                newVC.isSuccess = true
                newVC.addMoneyWalletAmount = self.amountTextField.text ?? ""
                newVC.isAddMoneyWallet = true
                newVC.transactionDetails = self.transactionDetails
                self.navigationController?.pushViewController(newVC, animated: true)
                NotificationCenter.default.post(name:  Notification.Name("viewWalletBalanceByIdApi"), object: self)
            }
        }
    }
    
}

//MARK: Collection View Setup
extension AddMoneyInWalletViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return addMoneyAmountArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddMoneyAmountCollectionViewCell", for: indexPath) as! AddMoneyAmountCollectionViewCell
        cell.addMoneyAmountLabel.text = "\(addMoneyAmountArr[indexPath.row])"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.amountTextField.text = "\(addMoneyAmountArr[indexPath.row])"
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((collectionView.frame.width) / 3.5), height: 40 )
    }
    
}

// MARK: - TextField Delegate Methods
extension AddMoneyInWalletViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        switch textField {
        case amountTextField:
            if amountTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
                self.amountValidationLbl.isHidden = false
                self.amountValidationLbl.text = ValidationManager.shared.emptyAmount
            } else {
                self.amountValidationLbl.isHidden = true
            }
        default:
            break
        }
    }
    
}
