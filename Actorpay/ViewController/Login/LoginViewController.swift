//
//  LoginViewController.swift
//  Actorpay
//
//  Created by iMac on 01/12/21.
//

import UIKit
import NKVPhonePicker
import DropDown

class LoginViewController: UIViewController {
    
//    MARK: - Properties -
    
    @IBOutlet weak var loginButton:UIButton!
    @IBOutlet weak var loginLineView:UIView!
    @IBOutlet weak var signUpButton:UIButton!
    @IBOutlet weak var signUpLineView:UIView!
    @IBOutlet weak var loginView:UIView!
    @IBOutlet weak var signUpView:UIView!
    
    // Login
    @IBOutlet weak var userNameTextField:UITextField!
    @IBOutlet weak var loginPasswordTextField:UITextField!
    
    //sign up
    @IBOutlet weak var userTypeTextField:UITextField!
    @IBOutlet weak var phoneCodeTextField: NKVPhonePickerTextField!
    @IBOutlet weak var phoneNumberTextField:UITextField!
    @IBOutlet weak var firstNameTextField:UITextField!
    @IBOutlet weak var lastNameTextField:UITextField!
    @IBOutlet weak var emailAddressTextField:UITextField!
    @IBOutlet weak var signUpPasswordTextField:UITextField!
    @IBOutlet weak var termsAndPrivacyLabel: UILabel!
    @IBOutlet weak var phoneCodeButton: UIButton!
        
    var isSignIn = true
    var isPassTap = false
    var isRememberMeTap = false
    var mobileCode: String?
    let dropDown = DropDown()
    
    // MARK: - Life cycle Functions -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpLineView.isHidden = true
        signUpView.isHidden = true
        phoneCodeTextField.delegate = self
        setupDropDown()
        signInUIManage()
        setSwipeGestureToView()
        setupMultipleTapLabel()
        numberPickerSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        selectedTabIndex = self.tabBarController?.selectedIndex ?? 0
    }

    
    //    MARK: - Selectors -
    
    @IBAction func loginAndSignupButton(_ sender: UIButton){
        if sender.tag == 1001 {
            isSignIn = true
            signInUIManage()
        }else{
            isSignIn = false
            signInUIManage()
        }
    }
    
    @IBAction func rememberMeButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        // remember Me
        isRememberMeTap = !isRememberMeTap
        if #available(iOS 13.0, *) {
            sender.setImage(UIImage(systemName: isRememberMeTap ? "checkmark" : ""), for: .normal)
            sender.tintColor = isRememberMeTap ? .white : .systemGray5
            sender.backgroundColor = isRememberMeTap ? UIColor(named: "BlueColor") : .none
            sender.borderColor = isRememberMeTap ? UIColor(named: "BlueColor") : .systemGray5
        }
    }
    
    @IBAction func newRegisterButton(_ sender: UIButton) {
        isSignIn = false
        signInUIManage()
    }
    
    @IBAction func alreadyLoginButton(_ sender: UIButton) {
        isSignIn = true
        signInUIManage()
    }
    
    @IBAction func passwordToggleButton(_ sender: UIButton) {
        self.view.endEditing(true)
        if sender.tag == 1001{
            // login password
            isPassTap = !isPassTap
            loginPasswordTextField.isSecureTextEntry = !isPassTap
            sender.setImage(UIImage(named: isPassTap ? "hide" : "show"), for: .normal)
        }else{
            //signup Password
            isPassTap = !isPassTap
            signUpPasswordTextField.isSecureTextEntry = !isPassTap
            sender.setImage(UIImage(named: isPassTap ? "hide" : "show"), for: .normal)
        }
    }
    
    @IBAction func phoneCodeBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        print("Tap")
        if let delegate = phoneCodeTextField.phonePickerDelegate {
            let countriesVC = CountriesViewController.standardController()
            countriesVC.delegate = self as CountriesViewControllerDelegate
            let navC = UINavigationController.init(rootViewController: countriesVC)
            delegate.present(navC, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func dropdownButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        dropDown.show()
    }
    
    @IBAction func loginButtonAction(_ sender: UIButton) {
        //  Login Validation 
        if userNameTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            self.alertViewController(message: "Please Enter an username.")
            return
        }
        if loginPasswordTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            self.alertViewController(message: "Please Enter an Password.")
            return
        }
        
        let newVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeNav") as! UINavigationController
        myApp.window?.rootViewController = newVC
    
//        let newVC = self.storyboard?.instantiateViewController(withIdentifier: "RootViewController") as! RootViewController
//        self.navigationController?.pushViewController(newVC, animated: true)
    }
    
    @IBAction func signupButtonAction(_ sender: UIButton) {
        //  Signin Validation
        if userTypeTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            self.alertViewController(message: "Please select an user type.")
            return
        }
        if phoneCodeTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            self.alertViewController(message: "Please Select Country Code.")
            return
        }
        if phoneNumberTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            self.alertViewController(message: "Please Enter a phone number.")
            return
        }
        if firstNameTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            self.alertViewController(message: "Please Enter a first name.")
            return
        }
        if lastNameTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            self.alertViewController(message: "Please Enter a last name.")
            return
        }
        if emailAddressTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            self.alertViewController(message: "Please Enter an email.")
            return
        }
        if !isValidEmail(emailAddressTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""){
            self.alertViewController(message: "Please enter a valid Email ID.")
            return
        }
        if signUpPasswordTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            self.alertViewController(message: "Please Enter a Password.")
            return
        }
    }
    
    @objc func handleSwipes(_ sender: UISwipeGestureRecognizer)
    {
        if sender.direction == .right {
            isSignIn = true
            signInUIManage()
        }
        
        if sender.direction == .left {
            isSignIn = false
            signInUIManage()
        }
    }
    
    @objc func tapLabel(gesture: UITapGestureRecognizer) {
        if gesture.didTapAttributedTextInLabel(label: termsAndPrivacyLabel, targetText: "Terms of Use") {
            print("Terms of Use")
        } else if gesture.didTapAttributedTextInLabel(label: termsAndPrivacyLabel, targetText: "Privacy Policy") {
            print("Privacy Policy")
        }
    }
    
    //    MARK: - helper Functions -
    
    func setupDropDown()  {
        dropDown.anchorView = userTypeTextField
        dropDown.dataSource = ["New","Old"]
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.userTypeTextField.text = item
            self.view.endEditing(true)
            self.dropDown.hide()
        }
        
        dropDown.bottomOffset = CGPoint(x: 0, y: 50)
        dropDown.direction = .bottom
    }
  
    
    func signInUIManage(){
        // login and Signup Manage
        signUpView.isHidden = isSignIn
        loginView.isHidden = !isSignIn
        signUpLineView.isHidden = isSignIn
        loginLineView.isHidden = !isSignIn
        loginButton.setTitleColor((isSignIn) ? UIColor.init(hexFromString: "#2878B6") : UIColor.darkGray, for: .normal)
        signUpButton.setTitleColor((!isSignIn) ? UIColor.init(hexFromString: "#2878B6") : UIColor.darkGray, for: .normal)
        // login
        userNameTextField.text = nil
        loginPasswordTextField.text = nil
        // Signup
        userTypeTextField.text = nil
        phoneNumberTextField.text = nil
        firstNameTextField.text = nil
        lastNameTextField.text = nil
        emailAddressTextField.text = nil
        signUpPasswordTextField.text = nil
    }
    
    func setSwipeGestureToView() {
//        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
//        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        
//        leftSwipe.direction = .left
//        rightSwipe.direction = .right
//
//        view.addGestureRecognizer(leftSwipe)
//        view.addGestureRecognizer(rightSwipe)
    }
    
    func numberPickerSetup() {
        phoneCodeTextField.phonePickerDelegate = self
        phoneCodeTextField.countryPickerDelegate = self
        phoneCodeTextField.flagSize = CGSize(width: 20, height: 10)
        phoneCodeTextField.flagInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        phoneCodeTextField.shouldScrollToSelectedCountry = false
        phoneCodeTextField.enablePlusPrefix = true
        
        if ((UserDefaults.standard.string(forKey: "countryCode")) != nil) {
            let code = (UserDefaults.standard.string(forKey: "countryCode") ?? Locale.current.regionCode) ?? ""
            let country = Country.country(for: NKVSource(countryCode: code))
            phoneCodeTextField.country = country
            phoneCodeTextField.text = country?.phoneExtension
//            phoneCodeButton.setAttributedTitle(attributedString(countryCode: "+\(country?.phoneExtension ?? "")", arrow: " ▾"), for: .normal)
            phoneCodeTextField.setCode(source: NKVSource(country: country!))
            mobileCode = country?.phoneExtension ?? ""
            UserDefaults.standard.synchronize()
        } else {
            let code = "it"
            let country = Country.country(for: NKVSource(countryCode: code))
            phoneCodeTextField.country = country
            phoneCodeTextField.text = country?.phoneExtension
//            phoneCodeButton.setAttributedTitle(attributedString(countryCode: "+\(country?.phoneExtension ?? "")", arrow: " ▾"), for: .normal)
            phoneCodeTextField.setCode(source: NKVSource(country: country!))
            mobileCode = country?.phoneExtension ?? ""
        }
    }
    
    func setupMultipleTapLabel() {
        termsAndPrivacyLabel.text = "By Signing up you are agreeing to our \n Terms of Use and Privacy Policy"
        let text = (termsAndPrivacyLabel.text)!
        let underlineAttriString = NSMutableAttributedString(string: text)
        let termsRange = (text as NSString).range(of: "Terms of Use")
        let privacyRange = (text as NSString).range(of: "Privacy Policy")
        underlineAttriString.addAttribute(.foregroundColor, value: UIColor.init(hexFromString: "#009EEF"), range: termsRange)
        underlineAttriString.addAttribute(.foregroundColor, value: UIColor.init(hexFromString: "#009EEF"), range: privacyRange)
        termsAndPrivacyLabel.attributedText = underlineAttriString
        let tapAction = UITapGestureRecognizer(target: self, action: #selector(self.tapLabel(gesture:)))
        termsAndPrivacyLabel.isUserInteractionEnabled = true
        termsAndPrivacyLabel.addGestureRecognizer(tapAction)
    }
}

//MARK:- Extensions -

extension UITapGestureRecognizer {
    func didTapAttributedTextInLabel(label: UILabel, targetText: String) -> Bool {
        guard let attributedString = label.attributedText, let lblText = label.text else { return false }
        let targetRange = (lblText as NSString).range(of: targetText)
        //IMPORTANT label correct font for NSTextStorage needed
        let mutableAttribString = NSMutableAttributedString(attributedString: attributedString)
        mutableAttribString.addAttributes(
            [NSAttributedString.Key.font: label.font ?? UIFont.smallSystemFontSize],
            range: NSRange(location: 0, length: attributedString.length)
        )
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: mutableAttribString)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                          y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y:
                                                        locationOfTouchInLabel.y - textContainerOffset.y);
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
}

extension LoginViewController: CountriesViewControllerDelegate, UITextFieldDelegate {
    func countriesViewController(_ sender: CountriesViewController, didSelectCountry country: Country) {
        print("✳️ Did select country: \(country.countryCode)")
        UserDefaults.standard.set(country.countryCode, forKey: "countryCode")
        mobileCode = country.phoneExtension
//        phoneCodeButton.setAttributedTitle(attributedString(countryCode: "+\(country.phoneExtension)", arrow: " ▾"), for: .normal)
        phoneCodeTextField.country = country
    }
    
    func countriesViewControllerDidCancel(_ sender: CountriesViewController) {
        print("😕")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
