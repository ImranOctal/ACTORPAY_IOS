//
//  TransferMoneyViewController.swift
//  Actorpay
//
//  Created by iMac on 09/02/22.
//

import UIKit
import Alamofire

class TransferMoneyViewController: UIViewController {
    
    //MARK: - Properties -
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var phoneOrEmailTextField: UITextField! {
        didSet {
            self.phoneOrEmailTextField.delegate = self
        }
    }
    @IBOutlet weak var amountTextField: UITextField! {
        didSet {
            self.amountTextField.delegate = self
        }
    }
    @IBOutlet weak var sendMoneyResonTextView: UITextView! {
        didSet {
            self.sendMoneyResonTextView.delegate = self
        }
    }
    @IBOutlet weak var phoneOrEmailValidationLbl: UILabel!
    @IBOutlet weak var sendMoneyResonValidationLbl: UILabel!
    @IBOutlet weak var amountValidationLbl: UILabel!
    @IBOutlet weak var phoneOrEmailTextFieldView: UIView!
    
    var placeHolder = ""
    var sendMoneyType : String = ""
    var userDetail : UserDetails?
    var transactionDetails: TransactionDetails?
    var toUserDetail = ""
    
    //MARK: - Life Cycles -
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        topCorner(bgView: mainView, maskToBounds: true)
        self.setUpTextView()
        self.manageValidationLabel()
        self.setUserDetails()
    }
    
    //MARK: - Selectors -
    
    // Back Button Action
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.tabBarController?.selectedIndex = selectedTabIndex
        self.navigationController?.popViewController(animated: true)
    }
    
    // Pay Now View Button Action
    @IBAction func payNowButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if transferMoneyValidation() {
            self.manageValidationLabel()
            self.transferMoneyToWalletApi()
        }
    }
    
    //MARK: - Helper Functions -
    
    // Phone Number View Validation
    func transferMoneyValidation() -> Bool {
        
        var isValidate = true
        
        if sendMoneyType == "Phone Number" {
            if phoneOrEmailTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
                phoneOrEmailValidationLbl.isHidden = false
                phoneOrEmailValidationLbl.text = ValidationManager.shared.emptyPhone
                isValidate = false
            } else if !isValidMobileNumber(mobileNumber: phoneOrEmailTextField.text ?? "") {
                phoneOrEmailValidationLbl.isHidden = false
                phoneOrEmailValidationLbl.text = ValidationManager.shared.validPhone
                isValidate = false
            } else {
                phoneOrEmailValidationLbl.isHidden = true
            }
        } else if sendMoneyType == "Email Address" {
            if phoneOrEmailTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
                phoneOrEmailValidationLbl.isHidden = false
                phoneOrEmailValidationLbl.text = ValidationManager.shared.lEmail
                isValidate = false
            } else if !isValidEmail(phoneOrEmailTextField.text ?? "") {
                phoneOrEmailValidationLbl.isHidden = false
                phoneOrEmailValidationLbl.text = ValidationManager.shared.fPassEmailInvalid
                isValidate = false
            } else {
                phoneOrEmailValidationLbl.isHidden = true
            }
        } else {
            phoneOrEmailValidationLbl.isHidden = true
        }
        
        if amountTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
            amountValidationLbl.isHidden = false
            amountValidationLbl.text = ValidationManager.shared.emptyAmount
            isValidate = false
        } else {
            amountValidationLbl.isHidden = true
        }
        
        if sendMoneyResonTextView.text?.trimmingCharacters(in: .whitespaces).count == 0 || sendMoneyResonTextView.text == placeHolder {
            sendMoneyResonValidationLbl.isHidden = false
            sendMoneyResonValidationLbl.text = ValidationManager.shared.emptyMobileDesc
            isValidate = false
        } else {
            sendMoneyResonValidationLbl.isHidden = true
        }
        
        return isValidate
    }
    
    // Manage Validation Lbl
    func manageValidationLabel() {
        self.phoneOrEmailValidationLbl.isHidden = true
        self.sendMoneyResonValidationLbl.isHidden = true
        self.amountValidationLbl.isHidden = true
    }
    
    // SetUp Text View
    func setUpTextView() {
        placeHolder = "Reason for sending Money"
        sendMoneyResonTextView.text = placeHolder
        if sendMoneyResonTextView.text == placeHolder {
            sendMoneyResonTextView.textColor = .lightGray
        } else {
            sendMoneyResonTextView.textColor = .black
        }
    }
    
    // Set User Details
    func setUserDetails() {
        titleLbl.text = "Pay to \(userDetail?.firstName ?? "") \(userDetail?.lastName ?? "")"
        if sendMoneyType == "Phone Number" {
            phoneOrEmailTextField.text = toUserDetail //userDetail?.contactNumber
            phoneOrEmailTextField.placeholder = "Enter Phone Number"
            phoneOrEmailTextFieldView.isHidden = false
        } else if sendMoneyType == "Email Address" {
            phoneOrEmailTextField.placeholder = "Enter Email Address"
            phoneOrEmailTextField.text = toUserDetail // user?.email
            phoneOrEmailTextFieldView.isHidden = false
        } else if sendMoneyType == "Pay Now" {
            phoneOrEmailTextFieldView.isHidden = true
        }
    }
    
}

//MARK: - Extensions -

//MARK: Api Call
extension TransferMoneyViewController {
    
    // Add Money In Wallet Api
    func transferMoneyToWalletApi() {
        let bodyParameter: Parameters = [
            "userIdentity": phoneOrEmailTextField.text ?? "",
            "amount": amountTextField.text ?? "",
            "transactionReason": sendMoneyResonTextView.text ?? ""
        ]
        showLoading()
        APIHelper.transferMoneyToWalletApi(bodyParameter: bodyParameter) { (success,response)  in
            if !success {
                dissmissLoader()
                let message = response.message
                myApp.window?.rootViewController?.view.makeToast(message)
                let newVC = self.storyboard?.instantiateViewController(withIdentifier: "PaymentSuccessAndFailViewController") as! PaymentSuccessAndFailViewController
                newVC.isSuccess = false
                self.navigationController?.pushViewController(newVC, animated: true)
            }else {
                dissmissLoader()
                let message = response.message
//                myApp.window?.rootViewController?.view.makeToast(message)
                print(message)
                let data = response.response["data"]
                self.transactionDetails = TransactionDetails.init(json: data)
                let newVC = self.storyboard?.instantiateViewController(withIdentifier: "PaymentSuccessAndFailViewController") as! PaymentSuccessAndFailViewController
                newVC.isSuccess = true
                newVC.transactionDetails = self.transactionDetails
                newVC.addMoneyWalletAmount = self.amountTextField.text ?? ""
                newVC.userDetail = self.userDetail
                self.navigationController?.pushViewController(newVC, animated: true)
                NotificationCenter.default.post(name:  Notification.Name("viewWalletBalanceByIdApi"), object: self)
            }
        }
    }
    
}

//MARK: UITextField Delegate Methods
extension TransferMoneyViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        switch textField {
        case phoneOrEmailTextField:
            if sendMoneyType == "Phone Number" {
                if phoneOrEmailTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
                    phoneOrEmailValidationLbl.isHidden = false
                    phoneOrEmailValidationLbl.text = ValidationManager.shared.emptyPhone
                } else if !isValidMobileNumber(mobileNumber: phoneOrEmailTextField.text ?? "") {
                    phoneOrEmailValidationLbl.isHidden = false
                    phoneOrEmailValidationLbl.text = ValidationManager.shared.validPhone
                } else {
                    phoneOrEmailValidationLbl.isHidden = true
                }
            } else if sendMoneyType == "Email Address" {
                if phoneOrEmailTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
                    phoneOrEmailValidationLbl.isHidden = false
                    phoneOrEmailValidationLbl.text = ValidationManager.shared.lEmail
                } else if !isValidEmail(phoneOrEmailTextField.text ?? "") {
                    phoneOrEmailValidationLbl.isHidden = false
                    phoneOrEmailValidationLbl.text = ValidationManager.shared.fPassEmailInvalid
                } else {
                    phoneOrEmailValidationLbl.isHidden = true
                }
            } else {
                phoneOrEmailValidationLbl.isHidden = true
            }
        case amountTextField:
            if amountTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
                amountValidationLbl.isHidden = false
                amountValidationLbl.text = ValidationManager.shared.emptyAmount
            } else {
                amountValidationLbl.isHidden = true
            }
        default:
            break
        }
    }
    
}

//MARK: UITextViewDelegate Methods
extension TransferMoneyViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        switch textView {
        case sendMoneyResonTextView:
            if sendMoneyResonTextView.text == placeHolder {
                sendMoneyResonTextView.text = ""
            }
            if sendMoneyResonTextView.text == placeHolder {
                sendMoneyResonTextView.isSelectable = false
            } else {
                sendMoneyResonTextView.isSelectable = true
            }
        default:
            break
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        switch textView {
        case sendMoneyResonTextView:
            if sendMoneyResonTextView.text == placeHolder {
                sendMoneyResonTextView.text = nil
                
                sendMoneyResonTextView.textColor = UIColor.black
            }
            if sendMoneyResonTextView.text == placeHolder {
                sendMoneyResonTextView.isSelectable = false
            } else {
                sendMoneyResonTextView.isSelectable = true
            }
        default:
            break
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        switch textView {
        case sendMoneyResonTextView:
            if sendMoneyResonTextView.text == placeHolder {
                sendMoneyResonTextView.isSelectable = true
            } else {
                sendMoneyResonTextView.isSelectable = true
            }
        default:
            break
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        switch textView {
        case sendMoneyResonTextView:
            if sendMoneyResonTextView.text.count == 0 {
                sendMoneyResonTextView.text = placeHolder
                sendMoneyResonTextView.textColor = UIColor.lightGray
            } else {
                sendMoneyResonTextView.textColor = UIColor.black
            }
            if sendMoneyResonTextView.text == placeHolder {
                sendMoneyResonTextView.isSelectable = false
                sendMoneyResonValidationLbl.isHidden = false
                sendMoneyResonValidationLbl.text = ValidationManager.shared.emptyMobileDesc
            } else {
                sendMoneyResonTextView.isSelectable = true
                sendMoneyResonValidationLbl.isHidden = true
            }
        default:
            break
        }
    }
    
}
