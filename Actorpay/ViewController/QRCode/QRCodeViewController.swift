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
    @IBOutlet weak var phoneOrEmailTextField: UITextField!
    @IBOutlet weak var contactBookButton: UIButton!
    
    // QRCode View
    @IBOutlet weak var qrCodeView: UIView!
    @IBOutlet weak var walletToBankView: UIStackView!
    
    // PayNowView
    @IBOutlet weak var payNowView: UIView!
    @IBOutlet weak var payNowEnterAmountTextField: UITextField!
    @IBOutlet weak var payNowReasonSendMoneyTextView: UITextView!
    
    // PayPhoneNumberView
    @IBOutlet weak var phoneNumberView: UIView!
    @IBOutlet weak var enterPhoneNumerTextField: UITextField!
    @IBOutlet weak var phoneNumerEnterAmountTextField: UITextField!
    @IBOutlet weak var phoneNumerReasonSendMoneyTextView: UITextView!
    @IBOutlet weak var phoneNumerContactBookButton: UIButton!
    
    // PayEmailAddressView
    @IBOutlet weak var emailAddressView: UIView!
    @IBOutlet weak var enterEmailAddressTextField: UITextField!
    @IBOutlet weak var emailAddressEnterAmountTextField: UITextField!
    @IBOutlet weak var emailAddressReasonSendMoneyTextView: UITextView!
    
    // PayBaneficiaryAccountView
    @IBOutlet weak var baneficiaryAccountView: UIView! //baneficiary
    @IBOutlet weak var baneficiaryNameTextField: UITextField!
    @IBOutlet weak var baneficiaryAccountNumberTextField: UITextField!
    @IBOutlet weak var baneficiaryUniqueCodeTextField: UITextField!
    @IBOutlet weak var baneficiarySelectBranchTextField: UITextField!
    @IBOutlet weak var baneficiaryReasonSendMoneyTextView: UITextView!
    
    var isWalletToBank = false
    let dropDown = DropDown()
    var nameToSave = ""
    var userImage: UIImage?
    var numeroADiscar = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topCorner(bgView: mainView, maskToBounds: true)
        
        // Do any additional setup after loading the view.
        wallletUiManage()
        setupDropDown()
        payNowReasonSendMoneyTextView.placeholder = "Enter Reason"
        baneficiaryReasonSendMoneyTextView.placeholder = "Enter Reason"
        phoneNumerReasonSendMoneyTextView.placeholder = "Enter Reason"
        emailAddressReasonSendMoneyTextView.placeholder = "Enter Reason"        
        
        DispatchQueue.main.async {
            let scanner = QRCodeScannerController()
            scanner.delegate = self
            self.add(asChildViewController: scanner)
        }
    }
    
    //    MARK: - Selectors -
    
    @IBAction func walletToWalletOrBankButtonAction(_ sender: UIButton){
        if sender.tag == 1001 {
            isWalletToBank = false
            wallletUiManage()
        }else{
            isWalletToBank = true
            wallletUiManage()
        }
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.tabBarController?.selectedIndex = selectedTabIndex
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func openContactBookButtonAction(_ sender: UIButton) {
        let peoplePicker = CNContactPickerViewController()

        peoplePicker.delegate = self

        self.present(peoplePicker, animated: true, completion: nil)
    }
    
    @IBAction func payNowViewButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if payNowEnterAmountTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            self.alertViewController(message: "Please enter an amount.")
            return
        }
        //        if payNowReasonSendMoneyTextView.text?.trimmingCharacters(in: .whitespaces).count == 0{
        //            self.alertViewController(message: "Please Enter an Password.")
        //            return
        //        }
    }
    
    @IBAction func phoneNumberViewButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if enterPhoneNumerTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            self.alertViewController(message: "Please enter a phone number.")
            return
        }
        if phoneNumerEnterAmountTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            self.alertViewController(message: "Please enter an amount.")
            return
        }
        
        //        if phoneNumerReasonSendMoneyTextView.text?.trimmingCharacters(in: .whitespaces).count == 0{
        //            self.alertViewController(message: "Please Enter an Password.")
        //            return
        //        }
    }
    
    @IBAction func emailAddressViewButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if enterEmailAddressTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            self.alertViewController(message: "Please enter a phone number.")
            return
        }
        if emailAddressEnterAmountTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            self.alertViewController(message: "Please enter an amount.")
            return
        }
        
        //        if emailAddressReasonSendMoneyTextView.text?.trimmingCharacters(in: .whitespaces).count == 0{
        //            self.alertViewController(message: "Please Enter an Password.")
        //            return
        //        }
    }
    
    @IBAction func selectBranchDropdown(_ sender: UIButton) {
        self.view.endEditing(true)
        dropDown.show()
    }
    
    
    @IBAction func baneficiaryAccountViewButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if baneficiaryNameTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            self.alertViewController(message: "Please enter a Baneficiary Name.")
//            self.view.makeToast("Please enter a Baneficiary Name.", duration: 3.0, position: .bottom)
            return
        }
        if baneficiaryAccountNumberTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            self.alertViewController(message: "Please enter an account Number.")
            return
        }
        if baneficiaryUniqueCodeTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            self.alertViewController(message: "Please enter an Unique Code.")
            return
        }
        if baneficiarySelectBranchTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            self.alertViewController(message: "Please Select a Branch.")
            return
        }
        //        if baneficiaryReasonSendMoneyTextView.text?.trimmingCharacters(in: .whitespaces).count == 0{
        //            self.alertViewController(message: "Please Enter an Password.")
        //            return
        //        }
    }
    //MARK: - Helper Functions -
    
    func setupDropDown()  {
        dropDown.anchorView = baneficiarySelectBranchTextField
        dropDown.dataSource = ["Sarathana","Hirabag","Vesu","Kamrej"]
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.baneficiarySelectBranchTextField.text = item
            self.view.endEditing(true)
            self.dropDown.hide()
        }
        dropDown.bottomOffset = CGPoint(x: 0, y: 50)
        dropDown.direction = .bottom
        dropDown.backgroundColor = .white
    }
    
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
    
    private func add(asChildViewController viewController: UIViewController) {
        addChild(viewController)
        qrCodeView.addSubview(viewController.view)
        viewController.view.frame = qrCodeView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParent: self)
    }
    
}

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
