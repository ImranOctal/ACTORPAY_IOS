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
    var userDetail: UserDetails?
    var isApicalling = false
    
    //MARK: - Life Cycles -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        topCorner(bgView: mainView, maskToBounds: true)
        self.wallletUiManage()
        self.setupDropDown()
        self.setUpTextView()
        self.manageBaneficiaryValidationLbl()
        
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

    // Manage Baneficiary Validation Label
    func manageBaneficiaryValidationLbl() {
        baneficiaryNameValidationLbl.isHidden = true
        baneficiaryAccountNoValidationLbl.isHidden = true
        baneficiaryIFSCCodeValidationLbl.isHidden = true
        baneficiaryBranchValidationLbl.isHidden = true
        baneficiaryDescValidationLbl.isHidden = true
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
        baneficiaryAccountView.isHidden = false
    }
    
    // SetUp Text View
    func setUpTextView() {
        placeHolder = "Reason for sending Money"
        baneficiaryReasonSendMoneyTextView.text = placeHolder
        if baneficiaryReasonSendMoneyTextView.text == placeHolder {
            baneficiaryReasonSendMoneyTextView.textColor = .lightGray
        } else {
            baneficiaryReasonSendMoneyTextView.textColor = .black
        }

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

//MARK: Api Call
extension QRCodeViewController {
    
    // Get User Wallet Details Api
    @objc func getUserDetailByMobileAndEmail(isEmail: Bool = false, mobileAndEmail:String) {
        self.view.endEditing(true)
        showLoading()
        if isApicalling == true {
            self.isApicalling = false
            return
        } else{
            self.isApicalling = true
        }
        
        APIHelper.getUserDetailByMobileAndEmail(parameters: [:], mobileAndEmail: mobileAndEmail) { (success, response) in
            if !success {
                dissmissLoader()
                let message = response.message
                print(message)
                myApp.window?.rootViewController?.view.makeToast(message)
                self.isApicalling = false
            }else {
                dissmissLoader()
                self.isApicalling = false
                let data = response.response["data"]
                self.userDetail = UserDetails.init(json: data)
                let message = response.message
                print(message)
                let newVC = self.storyboard?.instantiateViewController(withIdentifier: "TransferMoneyViewController") as! TransferMoneyViewController
                newVC.sendMoneyType = isEmail ? "Email Address" :"Phone Number"
                newVC.userDetail = self.userDetail
                newVC.toUserDetail = mobileAndEmail
                self.navigationController?.pushViewController(newVC, animated: true)
                }
//                myApp.window?.rootViewController?.view.makeToast(message)
        }
    }
    
}

//MARK: UITextField Delegate Methods
extension QRCodeViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        switch textField {
        
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
        
        default:
            break
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case phoneOrEmailTextField:
            if validatePhoneNumber() {
                self.getUserDetailByMobileAndEmail(isEmail: false,mobileAndEmail: textField.text ?? "")
            } else if validateEmailAddress() {
                self.getUserDetailByMobileAndEmail(isEmail: true,mobileAndEmail: textField.text ?? "")
            } else {
                return false
            }
        default:
            break
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case phoneOrEmailTextField:
            if validatePhoneNumber() {
                self.getUserDetailByMobileAndEmail(isEmail: false,mobileAndEmail: textField.text ?? "")
            } else if validateEmailAddress() {
                self.getUserDetailByMobileAndEmail(isEmail: true,mobileAndEmail: textField.text ?? "")
            }
        default:
            break
        }
    }
    
}

//MARK: UITextViewDelegate Methods
extension QRCodeViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        switch textView {
        case baneficiaryReasonSendMoneyTextView:
            if baneficiaryReasonSendMoneyTextView.text == placeHolder {
                baneficiaryReasonSendMoneyTextView.text = ""
            }
            if baneficiaryReasonSendMoneyTextView.text == placeHolder {
                baneficiaryReasonSendMoneyTextView.isSelectable = false
            } else {
                baneficiaryReasonSendMoneyTextView.isSelectable = true
            }
        
        default:
            break
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        switch textView {
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
        
        default:
            break
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        switch textView {
        case baneficiaryReasonSendMoneyTextView:
            if baneficiaryReasonSendMoneyTextView.text == placeHolder {
                baneficiaryReasonSendMoneyTextView.isSelectable = true
            } else {
                baneficiaryReasonSendMoneyTextView.isSelectable = true
            }
        
        default:
            break
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        switch textView {
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
        
        default:
            break
        }
    }
    
}

//MARK: QR Code Scanner Delegate Methods
extension QRCodeViewController: QRScannerCodeDelegate {
    
    func qrScanner(_ controller: UIViewController, scanDidComplete result: String) {
        print(result)
        let newVC = self.storyboard?.instantiateViewController(withIdentifier: "TransferMoneyViewController") as! TransferMoneyViewController
        newVC.sendMoneyType = "Pay Now"
        self.navigationController?.pushViewController(newVC, animated: true)
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
                        self.phoneOrEmailTextField.text = (actualNumber.stringValue).replacingOccurrences(of: "-", with: "", options: .literal, range: nil)
                        self.getUserDetailByMobileAndEmail(isEmail: false,mobileAndEmail: self.phoneOrEmailTextField.text ?? "")
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
                    phoneNumberLabel = phoneNumberLabel?.replacingOccurrences(of: "-", with: "")
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
                    self.phoneOrEmailTextField.text = (actualNumber.stringValue).replacingOccurrences(of: "-", with: "", options: .literal, range: nil)
                    self.getUserDetailByMobileAndEmail(isEmail: false,mobileAndEmail: self.phoneOrEmailTextField.text ?? "")
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
