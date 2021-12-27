//
//  LoginViewController.swift
//  Actorpay
//
//  Created by iMac on 01/12/21.
//

import UIKit
import NKVPhonePicker
import DropDown
import SwiftyJSON
import Alamofire

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
    @IBOutlet weak var genderTextField:UITextField!
    @IBOutlet weak var dateOfBirthTextField: UITextField!
    @IBOutlet weak var emailAddressTextField:UITextField!
    @IBOutlet weak var signUpPasswordTextField:UITextField!
    @IBOutlet weak var pancardOrAdharCardNumberTextField:UITextField!
    @IBOutlet weak var termsAndPrivacyLabel: UILabel!
    @IBOutlet weak var phoneCodeButton: UIButton!
    
    var isSignIn = true
    var isPassTap = false
    var isRememberMeTap = false
    var mobileCode: String?
    let dropDown = DropDown()
    var datePicker = UIDatePicker()
    var datePickerConstraints = [NSLayoutConstraint]()
    var blurEffectView = UIView()
    var imagePicker = UIImagePickerController()
    
    // MARK: - Life cycle Functions -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpLineView.isHidden = true
        signUpView.isHidden = true
        phoneCodeTextField.delegate = self
        dateOfBirthTextField.delegate = self
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
    
    @IBAction func showCalender(_ sender: UIButton) {
        self.view.endEditing(true)
        showDatePicker()
    }
    
    @IBAction func uploadDocumentButton(_ sender: UIButton) {
        self.view.endEditing(true)
        let alertController = UIAlertController(title:NSLocalizedString("title", comment: ""), message: "", preferredStyle: .actionSheet)
             let okAction = UIAlertAction(title: NSLocalizedString("ChooseExisting", comment: ""), style: .default) { (action) in
                 self.openPhotos()
             }
             let okAction2 = UIAlertAction(title: NSLocalizedString("TakePhoto", comment: ""), style: .default) { (action) in
                 self.openCamera()
             }
             let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
             alertController.addAction(okAction)
             alertController.addAction(okAction2)
             alertController.addAction(cancelAction)
             self.present(alertController, animated: true, completion: nil)
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
    
    @IBAction func forgotPasswordButton(_ sender: UIButton) {
        let popOverConfirmVC = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
        self.addChild(popOverConfirmVC)
        popOverConfirmVC.view.frame = self.view.frame
        self.view.center = popOverConfirmVC.view.center
        self.view.addSubview(popOverConfirmVC.view)
        popOverConfirmVC.didMove(toParent: self)
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
            self.view.makeToast( "Please Enter an username.")
            return
        }
        if loginPasswordTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            self.view.makeToast( "Please Enter an Password.")
            return
        }
        
        let params: Parameters = [
            "email": "\(userNameTextField.text ?? "")",
            "password": "\(loginPasswordTextField.text ?? "")",
            "device_id": deviceID(),
            "device_type": "iOS",
            "app_version": appVersion(),
            "device_data": [
                "api_level": "",
                "device": "Apple",
                "model": "\(UIDevice.modelName)",
                "product": "Apple",
                "brand": "Apple"
            ]
        ]
        showLoading()
        APIHelper.loginUser(params: params) { (success,response)  in
            if !success {
                dissmissLoader()
                let message = response.message
                myApp.window?.rootViewController?.view.makeToast(message)
            }else {
                dissmissLoader()
                let data = response.response["data"]
                user = User.init(json: data)
                AppManager.shared.token = user?.access_token ?? ""
                AppManager.shared.userId = user?.id ?? ""
                //                AppUserDefaults.saveObject(self.user?.access_token, forKey: .userAuthToken)
                let newVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeNav") as! UINavigationController
                myApp.window?.rootViewController = newVC
                myApp.window?.rootViewController?.view.makeToast(response.message)
            }
        }
    }
    
    @IBAction func signupButtonAction(_ sender: UIButton) {
        //  Signin Validation
//        if userTypeTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
//            self.view.makeToast( "Please select an user type.")
//            return
//        }
        if firstNameTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            self.view.makeToast("Please Enter a first name.")
            return
        }
        if lastNameTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            self.view.makeToast( "Please Enter a last name.")
            return
        }
        if emailAddressTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            self.view.makeToast( "Please Enter an email.")
            return
        }
        if !isValidEmail(emailAddressTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""){
            self.view.makeToast( "Please enter a valid Email ID.")
            return
        }
        if phoneCodeTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            self.view.makeToast( "Please Select Country Code.")
            return
        }
        if phoneNumberTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            self.view.makeToast( "Please Enter a phone number.")
            return
        }
        if signUpPasswordTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            self.view.makeToast( "Please Enter a Password.")
            return
        }
        if genderTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            self.view.makeToast( "Please select a gender.")
            return
        }
        if dateOfBirthTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            self.view.makeToast( "Please select a Date of Birth.")
            return
        }
        if dateOfBirthTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            self.view.makeToast( "Please select a Date of Birth.")
            return
        }
        if pancardOrAdharCardNumberTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            self.view.makeToast( "Please Enter a Pan Cardb Number or Adhar Card Number .")
            return
        }
        
        let params: Parameters = [
            "email":"\(emailAddressTextField.text ?? "")",
            "extensionNumber":"\(phoneCodeTextField.text ?? "")",
            "contactNumber":"\(phoneNumberTextField.text ?? "")",
            "password":"\(signUpPasswordTextField.text ?? "")",
            "gender":"\(genderTextField.text ?? "")",
            "firstName":"\(firstNameTextField.text ?? "")",
            "lastName":"\(lastNameTextField.text ?? "")",
            "dateOfBirth":"\(dateOfBirthTextField.text ?? "")"
        ]
        print(params)
        showLoading()
        APIHelper.registerUser(params: params) { (success,response)  in
            if !success {
                dissmissLoader()
                let message = response.message
                self.view.makeToast(message)
            }else {
                dissmissLoader()
                self.isSignIn = true
                self.signInUIManage()
                self.view.makeToast(response.message)
            }
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
            let newVC = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
            self.navigationController?.pushViewController(newVC, animated: true)
        } else if gesture.didTapAttributedTextInLabel(label: termsAndPrivacyLabel, targetText: "Privacy Policy") {
            print("Privacy Policy")
            let newVC = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
            self.navigationController?.pushViewController(newVC, animated: true)
        }
    }
    
    //    MARK: - helper Functions -
    
    func setupDropDown()  {
        dropDown.anchorView = genderTextField
        dropDown.dataSource = ["Female","Male","Other"]
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.genderTextField.text = item
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
        dateOfBirthTextField.text = nil
        genderTextField.text = nil
        pancardOrAdharCardNumberTextField.text = nil
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
        phoneCodeTextField.enablePlusPrefix = false
        
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
    
    func showDatePicker() {
        datePicker = UIDatePicker()
        datePicker.date = Date()
        datePicker.locale = .current
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .inline
        } else {
//            datePicker.preferredDatePickerStyle = .inline
        }
        datePicker.addTarget(self, action: #selector(dateSet), for: .valueChanged)
        addDatePickerToSubview()
        datePicker.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        datePicker.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }

        func addDatePickerToSubview() {
            // Give the background Blur Effect
            let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.regular)
            blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = self.view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.view.addSubview(blurEffectView)
            self.view.addSubview(datePicker)
            datePicker.translatesAutoresizingMaskIntoConstraints = false
            view.bringSubviewToFront(datePicker)
        }
    
    @objc func dateSet() {
        // Get the date from the Date Picker and put it in a Text Field
        dateOfBirthTextField.text = datePicker.date.formatted
        blurEffectView.removeFromSuperview()
        datePicker.removeFromSuperview()
    }
    func openCamera(){
        /// Open Camera
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }else{
            let alert  = UIAlertController(title: "Warning", message: "Camera Not Supported", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openPhotos(){
        ///Open Photo Gallary
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
    }
}


// MARK: - Extensions -

extension LoginViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage{
//            userImageView.image = image
            print(image)
            
        }
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}


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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == dateOfBirthTextField {
            if textField.text?.count == 2 || textField.text?.count == 5 {
                //Handle backspace being pressed
                if !(string == "") {
                    // append the text
                    if let text = textField.text {
                        textField.text = text + "-"
                    }
                }
            }
            // check the condition not exceed 9 chars
            return !(textField.text!.count > 9 && (string.count ) > range.length)
        } else {
            return true
        }
    }
   
    
}
