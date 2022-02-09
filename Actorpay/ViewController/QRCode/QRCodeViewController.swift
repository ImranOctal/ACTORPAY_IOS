//
//  QRCodeViewController.swift
//  Actorpay
//
//  Created by iMac on 03/12/21.
//

import UIKit
import DropDown
import Toast_Swift
import ContactsUI
//import SwiftQRScanner

class QRCodeViewController: UIViewController {
    
    //MARK: - Properites -
    
    //Main View
    @IBOutlet weak var mainView: UIView!
    
    //Wallet Selection Button
    @IBOutlet weak var wallectButtonView: UIView!
    @IBOutlet weak var walletToWalletButton:UIButton!
    @IBOutlet weak var walletToBankButton:UIButton!
    @IBOutlet weak var walletToWalletButtonView:UIView!
    @IBOutlet weak var walletToBankButtonView:UIView!
    @IBOutlet weak var walletButtonViewHeightConstraint: NSLayoutConstraint! // Fixed 170
    
    //Phone Or Email TextField View
    @IBOutlet weak var phoneOrEmailTextFieldView: UIView!
    @IBOutlet weak var phoneOrEmailTextField: UITextField! {
        didSet {
            self.phoneOrEmailTextField.delegate = self
        }
    }
    @IBOutlet weak var contactBookButton: UIButton!
    
    // QRCode View
    @IBOutlet weak var qrCodeView: UIView!
    @IBOutlet weak var walletToBankView: UIStackView!
    
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
    
    // PayBaneficiaryAccountView
    @IBOutlet weak var baneficiaryAccountView: UIView!
    @IBOutlet weak var baneficiaryNameTextField: UITextField! {
        didSet {
            self.baneficiaryNameTextField.delegate = self
        }
    }
    @IBOutlet weak var baneficiaryAccountNumberTextField: UITextField!{
        didSet {
            self.baneficiaryAccountNumberTextField.delegate = self
        }
    }
    @IBOutlet weak var baneficiaryIFSCCodeTextField: UITextField! {
        didSet {
            self.baneficiaryIFSCCodeTextField.delegate = self
        }
    }
    @IBOutlet weak var baneficiarySelectBranchTextField: UITextField! {
        didSet {
            self.baneficiarySelectBranchTextField.delegate = self
        }
    }
    @IBOutlet weak var baneficiaryReasonSendMoneyTextView: UITextView! {
        didSet {
            self.baneficiaryReasonSendMoneyTextView.delegate = self
        }
    }
    @IBOutlet weak var baneficiaryNameValidationLbl: UILabel!
    @IBOutlet weak var baneficiaryAccountNoValidationLbl: UILabel!
    @IBOutlet weak var baneficiaryIFSCCodeValidationLbl: UILabel!
    @IBOutlet weak var baneficiaryBranchValidationLbl: UILabel!
    @IBOutlet weak var baneficiaryDescValidationLbl: UILabel!
    
    var isWalletToBank = false
    let dropDown = DropDown()
    var nameToSave = ""
    var userImage: UIImage?
    var numeroADiscar = ""
    var placeHolder = ""
    
    //MARK: - Life Cycles -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        topCorner(bgView: mainView, maskToBounds: true)
        self.wallletUiManage()
        self.setupDropDown()
        self.setUpTextView()
        self.managePayWithPhoneNoValidationLbl()
        self.managePayWithEmailAddressValidationLbl()
        self.manageBaneficiaryValidationLbl()
        self.managePayNowValidationLbl()
        DispatchQueue.main.async {
            let scanner = QRCodeScannerController()
            scanner.delegate = self
            self.add(asChildViewController: scanner)
        }
    }
    
    //    MARK: - Selectors -
    
    // Wallet to Wallet OR Bank to Wallet Button Action
    @IBAction func walletToWalletOrBankButtonAction(_ sender: UIButton){
        self.view.endEditing(true)
        if sender.tag == 1001 {
            isWalletToBank = false
            wallletUiManage()
        }else{
            isWalletToBank = true
            wallletUiManage()
        }
    }
    
    // Back Button Action
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.tabBarController?.selectedIndex = selectedTabIndex
        self.navigationController?.popViewController(animated: true)
    }
    
    // Open Contact Book Action
    @IBAction func openContactBookButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let peoplePicker = CNContactPickerViewController()
        peoplePicker.delegate = self
        self.present(peoplePicker, animated: true, completion: nil)
    }
    
    // Pay Now View Button Action
    @IBAction func payNowViewButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if payNowViewValidation() {
            self.managePayNowValidationLbl()
            let newVC = self.storyboard?.instantiateViewController(withIdentifier: "DummyTransactionViewController") as! DummyTransactionViewController
            self.navigationController?.pushViewController(newVC, animated: true)
        }
    }
    
    // Phone Number View PayNow Button Action
    @IBAction func phoneNumberViewButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if phoneNumberViewValidation() {
            self.managePayWithPhoneNoValidationLbl()
            let newVC = self.storyboard?.instantiateViewController(withIdentifier: "DummyTransactionViewController") as! DummyTransactionViewController
            self.navigationController?.pushViewController(newVC, animated: true)
        }
    }
    
    // Email Address View Pay Now Button Action
    @IBAction func emailAddressViewButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if emailAddressViewValidation() {
            self.managePayWithEmailAddressValidationLbl()
            let newVC = self.storyboard?.instantiateViewController(withIdentifier: "DummyTransactionViewController") as! DummyTransactionViewController
            self.navigationController?.pushViewController(newVC, animated: true)
        }
    }
    
    // Branch Drop Down Button Action
    @IBAction func selectBranchDropdown(_ sender: UIButton) {
        self.view.endEditing(true)
        dropDown.show()
    }
    
    // Banificiary View Pay Now Button Action
    @IBAction func baneficiaryAccountViewButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if baneficiaryViewValidation() {
            self.manageBaneficiaryValidationLbl()
            let newVC = self.storyboard?.instantiateViewController(withIdentifier: "DummyTransactionViewController") as! DummyTransactionViewController
            self.navigationController?.pushViewController(newVC, animated: true)
        }
    }
    
    //MARK: - Helper Functions -
    
    // Phone Number Validation
    func validatePhoneNumber() -> Bool {
        var isValidate = true
        if phoneOrEmailTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
            isValidate = false
        } else if !isValidMobileNumber(mobileNumber: phoneOrEmailTextField.text ?? "") {
            isValidate = false
        }
        return isValidate
    }
    
    // Email Address Validation
    func validateEmailAddress() -> Bool {
        var isValidate = true
        if phoneOrEmailTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
            isValidate = false
        } else if !isValidEmail(phoneOrEmailTextField.text?.trimmingCharacters(in: .whitespaces) ?? "") {
            isValidate = false
        }
        return isValidate
    }
    
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
    
    // Baneficiary View Validation
    func baneficiaryViewValidation() -> Bool {
        var isValidate = true
        
        if baneficiaryNameTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
            baneficiaryNameValidationLbl.isHidden = false
            baneficiaryNameValidationLbl.text = ValidationManager.shared.emptyBaneficiaryName
            isValidate = false
        } else {
            baneficiaryNameValidationLbl.isHidden = true
        }
        
        if baneficiaryAccountNumberTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
            baneficiaryAccountNoValidationLbl.isHidden = false
            baneficiaryAccountNoValidationLbl.text = ValidationManager.shared.emptyBaneficiaryAccountNo 
            isValidate = false
        } else {
            baneficiaryAccountNoValidationLbl.isHidden = true
        }
        
        if baneficiaryIFSCCodeTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
            baneficiaryIFSCCodeValidationLbl.isHidden = false
            baneficiaryIFSCCodeValidationLbl.text = ValidationManager.shared.emptyBaneficiaryIFSCCode
            isValidate = false
        } else {
            baneficiaryIFSCCodeValidationLbl.isHidden = true
        }
        
        if baneficiarySelectBranchTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
            baneficiaryBranchValidationLbl.isHidden = false
            baneficiaryBranchValidationLbl.text = ValidationManager.shared.emptyBaneficiaryBranchName
            isValidate = false
        } else {
            baneficiaryBranchValidationLbl.isHidden = true
        }
        
        if baneficiaryReasonSendMoneyTextView.text?.trimmingCharacters(in: .whitespaces).count == 0 || baneficiaryReasonSendMoneyTextView.text == placeHolder {
            baneficiaryDescValidationLbl.isHidden = false
            baneficiaryDescValidationLbl.text = ValidationManager.shared.emptyMobileDesc
            isValidate = false
        } else {
            baneficiaryDescValidationLbl.isHidden = true
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
    
    // Manage Baneficiary Validation Label
    func manageBaneficiaryValidationLbl() {
        baneficiaryNameValidationLbl.isHidden = true
        baneficiaryAccountNoValidationLbl.isHidden = true
        baneficiaryIFSCCodeValidationLbl.isHidden = true
        baneficiaryBranchValidationLbl.isHidden = true
        baneficiaryDescValidationLbl.isHidden = true
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
        
        baneficiaryReasonSendMoneyTextView.text = placeHolder
        if baneficiaryReasonSendMoneyTextView.text == placeHolder {
            baneficiaryReasonSendMoneyTextView.textColor = .lightGray
        } else {
            baneficiaryReasonSendMoneyTextView.textColor = .black
        }
        
        payNowReasonSendMoneyTextView.text = placeHolder
        if payNowReasonSendMoneyTextView.text == placeHolder {
            payNowReasonSendMoneyTextView.textColor = .lightGray
        } else {
            payNowReasonSendMoneyTextView.textColor = .black
        }
    }
    
    // Branch Drop Down SetUp
    func setupDropDown()  {
        dropDown.anchorView = baneficiarySelectBranchTextField
        dropDown.dataSource = ["Sarathana","Hirabag","Vesu","Kamrej"]
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.baneficiarySelectBranchTextField.text = item
            self.view.endEditing(true)
            self.dropDown.hide()
            if baneficiarySelectBranchTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
                baneficiaryBranchValidationLbl.isHidden = false
                baneficiaryBranchValidationLbl.text = ValidationManager.shared.emptyBaneficiaryBranchName
            } else {
                baneficiaryBranchValidationLbl.isHidden = true
            }
        }
        dropDown.bottomOffset = CGPoint(x: 0, y: 50)
        dropDown.direction = .bottom
        dropDown.backgroundColor = .white
    }
    
    // Wallet UI Manage
    func wallletUiManage(){
        // Wallet to wallet and WalletToBank View Manage
        walletToWalletButtonView.backgroundColor = (isWalletToBank) ? UIColor.init(hexFromString: "#64AED3") : UIColor.white
        walletToBankButtonView.backgroundColor = (!isWalletToBank) ? UIColor.init(hexFromString: "#64AED3") : UIColor.white
        walletToWalletButton.setTitleColor((isWalletToBank) ? UIColor.init(hexFromString: "#1C6388") : UIColor.black, for: .normal)
        walletToBankButton.setTitleColor((!isWalletToBank) ? UIColor.init(hexFromString: "#1C6388") : UIColor.black, for: .normal)
        qrCodeView.isHidden = isWalletToBank
        walletToBankView.isHidden = !isWalletToBank
        emailAddressView.isHidden = true
        phoneNumberView.isHidden = true
        payNowView.isHidden = true
    }
    
    // Add View To Sub View
    private func add(asChildViewController viewController: UIViewController) {
        addChild(viewController)
        qrCodeView.addSubview(viewController.view)
        viewController.view.frame = qrCodeView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParent: self)
    }
    
}

//MARK: - Extensions -

//MARK: UITextField Delegate Methods
extension QRCodeViewController: UITextFieldDelegate {
    
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
        case baneficiaryNameTextField:
            if baneficiaryNameTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
                baneficiaryNameValidationLbl.isHidden = false
                baneficiaryNameValidationLbl.text = ValidationManager.shared.emptyBaneficiaryName
            } else {
                baneficiaryNameValidationLbl.isHidden = true
            }
        case baneficiaryAccountNumberTextField:
            if baneficiaryAccountNumberTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
                baneficiaryAccountNoValidationLbl.isHidden = false
                baneficiaryAccountNoValidationLbl.text = ValidationManager.shared.emptyBaneficiaryAccountNo
            } else {
                baneficiaryAccountNoValidationLbl.isHidden = true
            }
        case baneficiaryIFSCCodeTextField:
            if baneficiaryIFSCCodeTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
                baneficiaryIFSCCodeValidationLbl.isHidden = false
                baneficiaryIFSCCodeValidationLbl.text = ValidationManager.shared.emptyBaneficiaryIFSCCode
            } else {
                baneficiaryIFSCCodeValidationLbl.isHidden = true
            }
        case baneficiarySelectBranchTextField:
            if baneficiarySelectBranchTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
                baneficiaryBranchValidationLbl.isHidden = false
                baneficiaryBranchValidationLbl.text = ValidationManager.shared.emptyBaneficiaryBranchName
            } else {
                baneficiaryBranchValidationLbl.isHidden = true
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case phoneOrEmailTextField:
            if validatePhoneNumber() {
                emailAddressView.isHidden = true
                payNowView.isHidden = true
                phoneNumberView.isHidden = false
                baneficiaryAccountView.isHidden = true
            } else if validateEmailAddress() {
                emailAddressView.isHidden = false
                payNowView.isHidden = true
                phoneNumberView.isHidden = true
                baneficiaryAccountView.isHidden = true
            } else {
                emailAddressView.isHidden = true
                payNowView.isHidden = true
                phoneNumberView.isHidden = true
                baneficiaryAccountView.isHidden = false
            }
        default:
            break
        }
        return true
    }
    
}

//MARK: UITextViewDelegate Methods
extension QRCodeViewController: UITextViewDelegate {
    
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
        case baneficiaryReasonSendMoneyTextView:
            if baneficiaryReasonSendMoneyTextView.text == placeHolder {
                baneficiaryReasonSendMoneyTextView.text = ""
            }
            if baneficiaryReasonSendMoneyTextView.text == placeHolder {
                baneficiaryReasonSendMoneyTextView.isSelectable = false
            } else {
                baneficiaryReasonSendMoneyTextView.isSelectable = true
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
        case baneficiaryReasonSendMoneyTextView:
            if baneficiaryReasonSendMoneyTextView.text == placeHolder {
                baneficiaryReasonSendMoneyTextView.text = nil
                
                baneficiaryReasonSendMoneyTextView.textColor = UIColor.black
            }
            if baneficiaryReasonSendMoneyTextView.text == placeHolder {
                baneficiaryReasonSendMoneyTextView.isSelectable = false
            } else {
                baneficiaryReasonSendMoneyTextView.isSelectable = true
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
        case baneficiaryReasonSendMoneyTextView:
            if baneficiaryReasonSendMoneyTextView.text == placeHolder {
                baneficiaryReasonSendMoneyTextView.isSelectable = true
            } else {
                baneficiaryReasonSendMoneyTextView.isSelectable = true
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
        case baneficiaryReasonSendMoneyTextView:
            if baneficiaryReasonSendMoneyTextView.text.count == 0 {
                baneficiaryReasonSendMoneyTextView.text = placeHolder
                baneficiaryReasonSendMoneyTextView.textColor = UIColor.lightGray
            } else {
                baneficiaryReasonSendMoneyTextView.textColor = UIColor.black
            }
            if baneficiaryReasonSendMoneyTextView.text == placeHolder {
                baneficiaryReasonSendMoneyTextView.isSelectable = false
                baneficiaryDescValidationLbl.isHidden = false
                baneficiaryDescValidationLbl.text = ValidationManager.shared.emptyMobileDesc
            } else {
                baneficiaryReasonSendMoneyTextView.isSelectable = true
                baneficiaryDescValidationLbl.isHidden = true
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

//MARK: QR Code Scanner Delegate Methods
extension QRCodeViewController: QRScannerCodeDelegate {
    
    func qrScanner(_ controller: UIViewController, scanDidComplete result: String) {
        print(result)
        payNowView.isHidden = (result.count == 0) ? true : false
        qrCodeView.isHidden = true
        //searchUsers(result)
    }
    
    func qrScannerDidFail(_ controller: UIViewController, error: String) {
        print("error:\(error)")
    }
    
    func qrScannerDidCancel(_ controller: UIViewController) {
        print("SwiftQRScanner did cancel")
    }
}

//MARK: Contact Picker Delegate Methods
extension QRCodeViewController: CNContactPickerDelegate {
    
    func contactPickerDidCancel(picker: CNContactPickerViewController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
        // I only want single selection
        if contacts.count != 1 {
            return
        } else {
            
            //Dismiss the picker VC
            picker.dismiss(animated: true, completion: nil)
            
            let contact: CNContact = contacts[0]
            
            //See if the contact has multiple phone numbers
            if contact.phoneNumbers.count > 1 {
                
                //If so we need the user to select which phone number we want them to use
                let multiplePhoneNumbersAlert = UIAlertController(title: "Which one?", message: "This contact has multiple phone numbers, which one did you want use?", preferredStyle: .alert)
                
                //Loop through all the phone numbers that we got back
                for number in contact.phoneNumbers {
                    
                    //Each object in the phone numbers array has a value property that is a CNPhoneNumber object, Make sure we can get that
                    let actualNumber = number.value as CNPhoneNumber
                    
                    //Get the label for the phone number
                    var phoneNumberLabel = number.label
                    
                    //Strip off all the extra crap that comes through in that label
                    phoneNumberLabel = phoneNumberLabel?.replacingOccurrences(of: "_", with: "")
                    phoneNumberLabel = phoneNumberLabel?.replacingOccurrences(of: "$", with: "")
                    phoneNumberLabel = phoneNumberLabel?.replacingOccurrences(of: "!", with: "")
                    phoneNumberLabel = phoneNumberLabel?.replacingOccurrences(of: "<", with: "")
                    phoneNumberLabel = phoneNumberLabel?.replacingOccurrences(of: ">", with: "")
                    
                    //Create a title for the action for the UIAlertVC that we display to the user to pick phone numbers
                    let actionTitle = phoneNumberLabel! + " - " + actualNumber.stringValue
                    
                    //Create the alert action
                    let numberAction = UIAlertAction(title: actionTitle, style: .default, handler: { (theAction) -> Void in
                        
                        //See if we can get A frist name
                        if contact.givenName == "" {
                            
                            //If Not check for a last name
                            if contact.familyName == "" {
                                //If no last name set name to Unknown Name
                                self.nameToSave = "Unknown Name"
                            }else{
                                self.nameToSave = contact.familyName
                            }
                        } else {
                            self.nameToSave = contact.givenName
                        }
                        // See if we can get image data
                        if let imageData = contact.imageData {
                            //If so create the image
                            self.userImage = UIImage(data: imageData)!
                        }
                        //Do what you need to do with your new contact information here!
                        //Get the string value of the phone number like this:
                        self.numeroADiscar = actualNumber.stringValue
                        self.phoneOrEmailTextField.text = actualNumber.stringValue
                    })
                    //Add the action to the AlertController
                    multiplePhoneNumbersAlert.addAction(numberAction)
                }
                //Add a cancel action
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (theAction) -> Void in
                    //Cancel action completion
                })
                //Add the cancel action
                multiplePhoneNumbersAlert.addAction(cancelAction)
                //Present the ALert controller
                self.present(multiplePhoneNumbersAlert, animated: true, completion: nil)
            } else {
                //Make sure we have at least one phone number
                if contact.phoneNumbers.count > 0 {
                    //If so get the CNPhoneNumber object from the first item in the array of phone numbers
                    let actualNumber = (contact.phoneNumbers.first?.value)! as CNPhoneNumber
                    //Get the label of the phone number
                    var phoneNumberLabel = contact.phoneNumbers.first!.label
                    //Strip out the stuff you don't need
                    phoneNumberLabel = phoneNumberLabel?.replacingOccurrences(of: "_", with: "")
                    phoneNumberLabel = phoneNumberLabel?.replacingOccurrences(of: "$", with: "")
                    phoneNumberLabel = phoneNumberLabel?.replacingOccurrences(of: "!", with: "")
                    phoneNumberLabel = phoneNumberLabel?.replacingOccurrences(of: "<", with: "")
                    phoneNumberLabel = phoneNumberLabel?.replacingOccurrences(of: ">", with: "")
                    //Create an empty string for the contacts name
                    self.nameToSave = ""
                    //See if we can get A frist name
                    if contact.givenName == "" {
                        //If Not check for a last name
                        if contact.familyName == "" {
                            //If no last name set name to Unknown Name
                            self.nameToSave = "Unknown Name"
                        }else{
                            self.nameToSave = contact.familyName
                        }
                    } else {
                        nameToSave = contact.givenName
                    }
                    // See if we can get image data
                    if let imageData = contact.imageData {
                        //If so create the image
                        self.userImage = UIImage(data: imageData)
                    }
                    //Do what you need to do with your new contact information here!
                    //Get the string value of the phone number like this:
                    self.phoneOrEmailTextField.text = actualNumber.stringValue
                } else {
                    //If there are no phone numbers associated with the contact I call a custom funciton I wrote that lets me display an alert Controller to the user
                    let alert = UIAlertController(title: "Missing info", message: "You have no phone numbers associated with this contact", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alert.addAction(cancelAction)
                    present(alert, animated: true, completion: nil)
                }
            }
        }
    }
}
