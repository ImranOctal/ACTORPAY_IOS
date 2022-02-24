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
    
    //Main View
    @IBOutlet weak var mainView: UIView!
    
    // PayNowView
    @IBOutlet weak var payNowView: UIView!
    @IBOutlet weak var payNowEnterAmountTextField: UITextField! {
        didSet {
            self.payNowEnterAmountTextField.delegate = self
        }
    }
    @IBOutlet weak var payNowReasonSendMoneyTextView: UITextView! {
        didSet {
            self.payNowReasonSendMoneyTextView.delegate = self
        }
    }
    @IBOutlet weak var payNowAmountValidationLbl: UILabel!
    @IBOutlet weak var payNowDescValidationLbl: UILabel!
    
    // PayPhoneNumberView
    @IBOutlet weak var phoneNumberView: UIView!
    @IBOutlet weak var enterPhoneNumerTextField: UITextField! {
        didSet {
            self.enterPhoneNumerTextField.delegate = self
        }
    }
    @IBOutlet weak var phoneNumerEnterAmountTextField: UITextField! {
        didSet {
            self.phoneNumerEnterAmountTextField.delegate = self
        }
    }
    @IBOutlet weak var phoneNumerReasonSendMoneyTextView: UITextView! {
        didSet {
            self.phoneNumerReasonSendMoneyTextView.delegate = self
        }
    }
    @IBOutlet weak var phoneNumerContactBookButton: UIButton!
    @IBOutlet weak var phoneNoValidationLbl: UILabel!
    @IBOutlet weak var phoneNoAmountValidationLbl: UILabel!
    @IBOutlet weak var phoneNoDescValidationLbl: UILabel!
    
    // PayEmailAddressView
    @IBOutlet weak var emailAddressView: UIView!
    @IBOutlet weak var enterEmailAddressTextField: UITextField! {
        didSet {
            self.enterEmailAddressTextField.delegate = self
        }
    }
    @IBOutlet weak var emailAddressEnterAmountTextField: UITextField! {
        didSet {
            self.emailAddressEnterAmountTextField.delegate = self
        }
    }
    @IBOutlet weak var emailAddressReasonSendMoneyTextView: UITextView! {
        didSet {
            self.emailAddressReasonSendMoneyTextView.delegate = self
        }
    }
    @IBOutlet weak var emailAddressValidationLbl: UILabel!
    @IBOutlet weak var emailAddressAmountValidationLbl: UILabel!
    @IBOutlet weak var emailAddressDescValidationLbl: UILabel!
    
    var placeHolder = ""
    var sendMoneyType : String = ""
    var emailAddress = ""
    var phoneNumber = ""
    
    //MARK: - Life Cycles -
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        topCorner(bgView: mainView, maskToBounds: true)
        self.manageView()
        self.setUpTextView()
        self.managePayWithPhoneNoValidationLbl()
        self.managePayWithEmailAddressValidationLbl()
        self.managePayNowValidationLbl()
        enterPhoneNumerTextField.text = emailAddress == "" ? phoneNumber : emailAddress
        enterEmailAddressTextField.text = emailAddress == "" ? phoneNumber : emailAddress
    }
    
    //MARK: - Selectors -
    
    // Back Button Action
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.tabBarController?.selectedIndex = selectedTabIndex
        self.navigationController?.popViewController(animated: true)
    }
    
    // Pay Now View Button Action
    @IBAction func payNowViewButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if payNowViewValidation() {
            self.managePayNowValidationLbl()
            self.transferMoneyToWalletApi()
        }
    }
    
    // Phone Number View PayNow Button Action
    @IBAction func phoneNumberViewButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if phoneNumberViewValidation() {
            self.managePayWithPhoneNoValidationLbl()
            self.transferMoneyToWalletApi()
        }
    }
    
    // Email Address View Pay Now Button Action
    @IBAction func emailAddressViewButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if emailAddressViewValidation() {
            self.managePayWithEmailAddressValidationLbl()
            self.transferMoneyToWalletApi()
        }
    }
    
    //MARK: - Helper Functions -
    
    // Phone Number View Validation
    func phoneNumberViewValidation() -> Bool {
        var isValidate = true
        if enterPhoneNumerTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
            phoneNoValidationLbl.isHidden = false
            phoneNoValidationLbl.text = ValidationManager.shared.emptyPhone
            isValidate = false
        } else if !isValidMobileNumber(mobileNumber: enterPhoneNumerTextField.text ?? "") {
            phoneNoValidationLbl.isHidden = false
            phoneNoValidationLbl.text = ValidationManager.shared.validPhone
            isValidate = false
        } else {
            phoneNoValidationLbl.isHidden = true
        }
        
        if phoneNumerEnterAmountTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
            phoneNoAmountValidationLbl.isHidden = false
            phoneNoAmountValidationLbl.text = ValidationManager.shared.emptyAmount
            isValidate = false
        } else {
            phoneNoAmountValidationLbl.isHidden = true
        }
        
        if phoneNumerReasonSendMoneyTextView.text?.trimmingCharacters(in: .whitespaces).count == 0 || phoneNumerReasonSendMoneyTextView.text == placeHolder {
            phoneNoDescValidationLbl.isHidden = false
            phoneNoDescValidationLbl.text = ValidationManager.shared.emptyMobileDesc
            isValidate = false
        } else {
            phoneNoDescValidationLbl.isHidden = true
        }
        
        return isValidate
    }
    
    // Email Address View Validation
    func emailAddressViewValidation() -> Bool {
        var isValidate = true
        
        if enterEmailAddressTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
            emailAddressValidationLbl.isHidden = false
            emailAddressValidationLbl.text = ValidationManager.shared.lEmail
            isValidate = false
        } else if !isValidEmail(enterEmailAddressTextField.text?.trimmingCharacters(in: .whitespaces) ?? "") {
            emailAddressValidationLbl.isHidden = false
            emailAddressValidationLbl.text = ValidationManager.shared.sEmailInvalid
            isValidate = false
        } else {
            emailAddressValidationLbl.isHidden = true
        }
        
        if emailAddressEnterAmountTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
            emailAddressAmountValidationLbl.isHidden = false
            emailAddressAmountValidationLbl.text = ValidationManager.shared.emptyAmount
            isValidate = false
        } else {
            emailAddressAmountValidationLbl.isHidden = true
        }
        
        if emailAddressReasonSendMoneyTextView.text?.trimmingCharacters(in: .whitespaces).count == 0 || emailAddressReasonSendMoneyTextView.text == placeHolder {
            emailAddressDescValidationLbl.isHidden = false
            emailAddressDescValidationLbl.text = ValidationManager.shared.emptyMobileDesc
            isValidate = false
        } else {
            emailAddressDescValidationLbl.isHidden = true
        }
        
        return isValidate
    }
    
    // Pay Now View Validation
    func payNowViewValidation() -> Bool {
        var isValidate = true
        if payNowEnterAmountTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
            payNowAmountValidationLbl.isHidden = false
            payNowAmountValidationLbl.text = ValidationManager.shared.emptyAmount
            isValidate = false
        } else {
            payNowAmountValidationLbl.isHidden = true
        }
        
        if payNowReasonSendMoneyTextView.text?.trimmingCharacters(in: .whitespaces).count == 0 {
            payNowDescValidationLbl.isHidden = false
            payNowDescValidationLbl.text = ValidationManager.shared.emptyMobileDesc
            isValidate = false
        } else {
            payNowDescValidationLbl.isHidden = true
        }
        return isValidate
    }
    
    // Manage Pay With Phone Number Validation Label
    func managePayWithPhoneNoValidationLbl() {
        phoneNoValidationLbl.isHidden = true
        phoneNoAmountValidationLbl.isHidden = true
        phoneNoDescValidationLbl.isHidden = true
    }
    
    // Manage Pay With Email Address Validation Label
    func managePayWithEmailAddressValidationLbl() {
        emailAddressValidationLbl.isHidden = true
        emailAddressAmountValidationLbl.isHidden = true
        emailAddressDescValidationLbl.isHidden = true
    }
    
    // Manage Pay Now Validation Label
    func managePayNowValidationLbl() {
        payNowAmountValidationLbl.isHidden = true
        payNowDescValidationLbl.isHidden = true
    }
    
    // SetUp Text View
    func setUpTextView() {
        placeHolder = "Reason for sending Money"
        
        phoneNumerReasonSendMoneyTextView.text = placeHolder
        if phoneNumerReasonSendMoneyTextView.text == placeHolder {
            phoneNumerReasonSendMoneyTextView.textColor = .lightGray
        } else {
            phoneNumerReasonSendMoneyTextView.textColor = .black
        }
        
        emailAddressReasonSendMoneyTextView.text = placeHolder
        if emailAddressReasonSendMoneyTextView.text == placeHolder {
            emailAddressReasonSendMoneyTextView.textColor = .lightGray
        } else {
            emailAddressReasonSendMoneyTextView.textColor = .black
        }
        
        payNowReasonSendMoneyTextView.text = placeHolder
        if payNowReasonSendMoneyTextView.text == placeHolder {
            payNowReasonSendMoneyTextView.textColor = .lightGray
        } else {
            payNowReasonSendMoneyTextView.textColor = .black
        }
    }
    
    // Manage UI View
    func manageView() {
        if sendMoneyType == "Phone Number" {
            phoneNumberView.isHidden = false
            emailAddressView.isHidden = true
            payNowView.isHidden = true
        } else if sendMoneyType == "Email Address" {
            phoneNumberView.isHidden = true
            emailAddressView.isHidden = false
            payNowView.isHidden = true
        } else if sendMoneyType == "Pay Now" {
            phoneNumberView.isHidden = true
            emailAddressView.isHidden = true
            payNowView.isHidden = false
        }
    }
    
}

//MARK: - Extensions -

//MARK: Api Call
extension TransferMoneyViewController {
    
    // Add Money In Wallet Api
    func transferMoneyToWalletApi() {
        let bodyParameter: Parameters = [
            "userIdentity": sendMoneyType == "Phone Number" ? enterPhoneNumerTextField.text ?? "" : enterEmailAddressTextField.text ?? "",
            "amount": sendMoneyType == "Phone Number" ? phoneNumerEnterAmountTextField.text ?? "" : emailAddressEnterAmountTextField.text ?? "",
            "transactionRemark": sendMoneyType == "Phone Number" ? phoneNumerReasonSendMoneyTextView.text ?? "" : emailAddressReasonSendMoneyTextView.text ?? ""
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
                let newVC = self.storyboard?.instantiateViewController(withIdentifier: "PaymentSuccessAndFailViewController") as! PaymentSuccessAndFailViewController
                newVC.isSuccess = true
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
        case enterPhoneNumerTextField:
            if enterPhoneNumerTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
                phoneNoValidationLbl.isHidden = false
                phoneNoValidationLbl.text = ValidationManager.shared.emptyPhone
            } else if !isValidMobileNumber(mobileNumber: enterPhoneNumerTextField.text ?? "") {
                phoneNoValidationLbl.isHidden = false
                phoneNoValidationLbl.text = ValidationManager.shared.validPhone
            } else {
                phoneNoValidationLbl.isHidden = true
            }
        case phoneNumerEnterAmountTextField:
            if phoneNumerEnterAmountTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
                phoneNoAmountValidationLbl.isHidden = false
                phoneNoAmountValidationLbl.text = ValidationManager.shared.emptyAmount
            } else {
                phoneNoAmountValidationLbl.isHidden = true
            }
        case enterEmailAddressTextField:
            if enterEmailAddressTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
                emailAddressValidationLbl.isHidden = false
                emailAddressValidationLbl.text = ValidationManager.shared.lEmail
            } else if !isValidEmail(enterEmailAddressTextField.text?.trimmingCharacters(in: .whitespaces) ?? "") {
                emailAddressValidationLbl.isHidden = false
                emailAddressValidationLbl.text = ValidationManager.shared.sEmailInvalid
            } else {
                emailAddressValidationLbl.isHidden = true
            }
        case emailAddressEnterAmountTextField:
            if emailAddressEnterAmountTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
                emailAddressAmountValidationLbl.isHidden = false
                emailAddressAmountValidationLbl.text = ValidationManager.shared.emptyAmount
            } else {
                emailAddressAmountValidationLbl.isHidden = true
            }
        case payNowEnterAmountTextField:
            if payNowEnterAmountTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
                payNowAmountValidationLbl.isHidden = false
                payNowAmountValidationLbl.text = ValidationManager.shared.emptyAmount
            } else {
                payNowAmountValidationLbl.isHidden = true
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
        case phoneNumerReasonSendMoneyTextView:
            if phoneNumerReasonSendMoneyTextView.text == placeHolder {
                phoneNumerReasonSendMoneyTextView.text = ""
            }
            if phoneNumerReasonSendMoneyTextView.text == placeHolder {
                phoneNumerReasonSendMoneyTextView.isSelectable = false
            } else {
                phoneNumerReasonSendMoneyTextView.isSelectable = true
            }
        case emailAddressReasonSendMoneyTextView:
            if emailAddressReasonSendMoneyTextView.text == placeHolder {
                emailAddressReasonSendMoneyTextView.text = ""
            }
            if emailAddressReasonSendMoneyTextView.text == placeHolder {
                emailAddressReasonSendMoneyTextView.isSelectable = false
            } else {
                emailAddressReasonSendMoneyTextView.isSelectable = true
            }
        case payNowReasonSendMoneyTextView:
            if payNowReasonSendMoneyTextView.text == placeHolder {
                payNowReasonSendMoneyTextView.text = ""
            }
            if payNowReasonSendMoneyTextView.text == placeHolder {
                payNowReasonSendMoneyTextView.isSelectable = false
            } else {
                payNowReasonSendMoneyTextView.isSelectable = true
            }
        default:
            break
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        switch textView {
        case phoneNumerReasonSendMoneyTextView:
            if phoneNumerReasonSendMoneyTextView.text == placeHolder {
                phoneNumerReasonSendMoneyTextView.text = nil
                
                phoneNumerReasonSendMoneyTextView.textColor = UIColor.black
            }
            if phoneNumerReasonSendMoneyTextView.text == placeHolder {
                phoneNumerReasonSendMoneyTextView.isSelectable = false
            } else {
                phoneNumerReasonSendMoneyTextView.isSelectable = true
            }
        case emailAddressReasonSendMoneyTextView:
            if emailAddressReasonSendMoneyTextView.text == placeHolder {
                emailAddressReasonSendMoneyTextView.text = nil
                
                emailAddressReasonSendMoneyTextView.textColor = UIColor.black
            }
            if emailAddressReasonSendMoneyTextView.text == placeHolder {
                emailAddressReasonSendMoneyTextView.isSelectable = false
            } else {
                emailAddressReasonSendMoneyTextView.isSelectable = true
            }
        case payNowReasonSendMoneyTextView:
            if payNowReasonSendMoneyTextView.text == placeHolder {
                payNowReasonSendMoneyTextView.text = nil
                
                payNowReasonSendMoneyTextView.textColor = UIColor.black
            }
            if payNowReasonSendMoneyTextView.text == placeHolder {
                payNowReasonSendMoneyTextView.isSelectable = false
            } else {
                payNowReasonSendMoneyTextView.isSelectable = true
            }
        default:
            break
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        switch textView {
        case phoneNumerReasonSendMoneyTextView:
            if phoneNumerReasonSendMoneyTextView.text == placeHolder {
                phoneNumerReasonSendMoneyTextView.isSelectable = true
            } else {
                phoneNumerReasonSendMoneyTextView.isSelectable = true
            }
        case emailAddressReasonSendMoneyTextView:
            if emailAddressReasonSendMoneyTextView.text == placeHolder {
                emailAddressReasonSendMoneyTextView.isSelectable = true
            } else {
                emailAddressReasonSendMoneyTextView.isSelectable = true
            }
        case payNowReasonSendMoneyTextView:
            if payNowReasonSendMoneyTextView.text == placeHolder {
                payNowReasonSendMoneyTextView.isSelectable = true
            } else {
                payNowReasonSendMoneyTextView.isSelectable = true
            }
        default:
            break
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        switch textView {
        case phoneNumerReasonSendMoneyTextView:
            if phoneNumerReasonSendMoneyTextView.text.count == 0 {
                phoneNumerReasonSendMoneyTextView.text = placeHolder
                phoneNumerReasonSendMoneyTextView.textColor = UIColor.lightGray
            } else {
                phoneNumerReasonSendMoneyTextView.textColor = UIColor.black
            }
            if phoneNumerReasonSendMoneyTextView.text == placeHolder {
                phoneNumerReasonSendMoneyTextView.isSelectable = false
                phoneNoDescValidationLbl.isHidden = false
                phoneNoDescValidationLbl.text = ValidationManager.shared.emptyMobileDesc
            } else {
                phoneNumerReasonSendMoneyTextView.isSelectable = true
                phoneNoDescValidationLbl.isHidden = true
            }
        case emailAddressReasonSendMoneyTextView:
            if emailAddressReasonSendMoneyTextView.text.count == 0 {
                emailAddressReasonSendMoneyTextView.text = placeHolder
                emailAddressReasonSendMoneyTextView.textColor = UIColor.lightGray
            } else {
                emailAddressReasonSendMoneyTextView.textColor = UIColor.black
            }
            if emailAddressReasonSendMoneyTextView.text == placeHolder {
                emailAddressReasonSendMoneyTextView.isSelectable = false
                emailAddressDescValidationLbl.isHidden = false
                emailAddressDescValidationLbl.text = ValidationManager.shared.emptyMobileDesc
            } else {
                emailAddressReasonSendMoneyTextView.isSelectable = true
                emailAddressDescValidationLbl.isHidden = true
            }
        case payNowReasonSendMoneyTextView:
            if payNowReasonSendMoneyTextView.text.count == 0 {
                payNowReasonSendMoneyTextView.text = placeHolder
                payNowReasonSendMoneyTextView.textColor = UIColor.lightGray
            } else {
                payNowReasonSendMoneyTextView.textColor = UIColor.black
            }
            if payNowReasonSendMoneyTextView.text == placeHolder {
                payNowReasonSendMoneyTextView.isSelectable = false
                payNowDescValidationLbl.isHidden = false
                payNowDescValidationLbl.text = ValidationManager.shared.emptyMobileDesc
            } else {
                payNowReasonSendMoneyTextView.isSelectable = true
                payNowDescValidationLbl.isHidden = true
            }
        default:
            break
        }
    }
    
}
