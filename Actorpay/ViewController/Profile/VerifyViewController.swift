//
//  VerifyViewController.swift
//  Actorpay
//
//  Created by iMac on 21/01/22.
//

import UIKit

class VerifyViewController: UIViewController {
    
    //MARK: - Properties -

    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var emailTextField: UITextField! {
        didSet {
            emailTextField.delegate = self
            emailTextField.becomeFirstResponder()
            emailTextField.keyboardType = .emailAddress
        }
    }
    
    @IBOutlet weak var phoneNumberView: UIView!
    @IBOutlet weak var phoneCodeTextField: UILabel! {
        didSet {
            phoneCodeTextField.text = AppManager.shared.countryCode
        }
    }
    @IBOutlet weak var countryImage: UIImageView! {
        didSet {
            countryImage.image = UIImage(named: AppManager.shared.countryFlag)
        }
    }
    @IBOutlet weak var phoneNumberField: UITextField! {
        didSet {
            phoneNumberField.delegate = self
            phoneNumberField.becomeFirstResponder()
            phoneNumberField.keyboardType = .numberPad
        }
    }
    
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorLbl: UILabel!
    
    var isEmailVerify = false
    
    //MARK: - Life Cycles -
    
    override func viewDidLoad() {
        super.viewDidLoad()

        headerLbl.text = isEmailVerify ? "Update Email" : "Update Phone"
        phoneNumberView.isHidden = isEmailVerify
        emailView.isHidden = !isEmailVerify
        errorView.isHidden = true
        topCorners(bgView: headerView, cornerRadius: 10, maskToBounds: true)
        bottomCorner(bgView: buttonView, cornerRadius: 10, maskToBounds: true)
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        self.showAnimate()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: - Selectors -
    
    // CAncel Button Action
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        removeAnimate()
        self.dismiss(animated: true, completion: nil)
    }
    
    // Ok Button Action
    @IBAction func okButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if isEmailVerify {
            if emailValidation() {
                print("Email")
            }
        }else{
            if phoneNumberValidation() {
                print("PhoneNumber")
            }
        }
    }
    
    @IBAction func phoneCodeBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let countriesVC = self.storyboard?.instantiateViewController(withIdentifier: "CountryViewController") as! CountryViewController
        countriesVC.onCompletion = {(code,flag,country) in
            AppManager.shared.countryCode = ""
            AppManager.shared.countryFlag = ""
            self.countryImage.sd_setImage(with: URL(string: flag), placeholderImage: UIImage(named: "IN.png"), completed: nil)
            self.phoneCodeTextField.text = code
        }
        let navC = UINavigationController.init(rootViewController: countriesVC)
        self.present(navC, animated: true, completion: nil)
    }
    
    //MARK: - Helper Functions -
    
    // Forgot Password Validation
    func emailValidation() -> Bool {
        var isValidate = true
        if emailTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            errorView.isHidden = false
            errorLbl.text = ValidationManager.shared.fPassEmail
            isValidate = false
        } else if !isValidEmail(emailTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""){
            errorView.isHidden = false
            errorLbl.text = ValidationManager.shared.fPassEmailInvalid
            isValidate = false
        } else {
            errorView.isHidden = true
        }
        return isValidate
    }
    
    func phoneNumberValidation() -> Bool {
        
        var isValidate = true
        
        if phoneCodeTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
            errorView.isHidden = false
            errorLbl.text = ValidationManager.shared.emptyPhoneCode
            isValidate = false
        }else {
            errorView.isHidden = true
        }
        
        if phoneNumberField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            errorView.isHidden = false
            errorLbl.text = ValidationManager.shared.emptyPhone
            isValidate = false
        } else if !isValidMobileNumber(mobileNumber: phoneNumberField.text ?? "") {
            errorView.isHidden = false
            errorLbl.text = ValidationManager.shared.validPhone
            isValidate = false
        } else {
            errorView.isHidden = true
        }
        
        return isValidate
        
    }
    
    // Present View With Animation
    func showAnimate(){
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    // Dismiss View With Animation
    func removeAnimate(){
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished){
                self.view.endEditing(true)
                self.view.removeFromSuperview()
            }
        });
    }

    // View End Editing
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(touches.first?.view != emailView){
            removeAnimate()
        }
    }
    
}

//MARK: - Extensions -

extension VerifyViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        switch textField {
        case emailTextField:
            if emailTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
                errorView.isHidden = false
                errorLbl.text = ValidationManager.shared.sEmail
//                isValidate = false
            } else if !isValidEmail(emailTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""){
                errorView.isHidden = false
                errorLbl.text = ValidationManager.shared.sEmailInvalid
//                isValidate = false
            } else {
                errorView.isHidden = true
            }
        case phoneNumberField:
            if phoneNumberField.text?.trimmingCharacters(in: .whitespaces).count == 0{
                errorView.isHidden = false
                errorLbl.text = ValidationManager.shared.emptyPhone
            } else if !isValidMobileNumber(mobileNumber: phoneNumberField.text ?? "") {
                errorView.isHidden = false
                errorLbl.text = ValidationManager.shared.validPhone
            } else {
                errorView.isHidden = true
            }
        default:
            break
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}
