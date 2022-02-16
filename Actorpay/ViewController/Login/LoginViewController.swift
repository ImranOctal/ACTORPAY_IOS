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
import GoogleSignIn
import FBSDKLoginKit
import FBSDKCoreKit
import IQKeyboardManagerSwift
import AuthenticationServices
import KeychainSwift
import PopupDialog

class LoginViewController: UIViewController {
    
    //    MARK: - Properties -
    
    @IBOutlet weak var loginButton:UIButton!
    @IBOutlet weak var loginLineView:UIView!
    @IBOutlet weak var signUpButton:UIButton!
    @IBOutlet weak var signUpLineView:UIView!
    @IBOutlet weak var loginView:UIView!
    @IBOutlet weak var signUpView:UIView!
    
    // Login
    @IBOutlet weak var loginEmailLabel:UILabel!
    @IBOutlet weak var loginPasswordLabel:UILabel!
    
    @IBOutlet weak var loginEmailTextField:UITextField! {
        didSet {
            loginEmailTextField.delegate = self
            loginEmailTextField.keyboardType = .emailAddress
        }
    }
    @IBOutlet weak var loginPasswordTextField:UITextField! {
        didSet {
            loginPasswordTextField.delegate = self
        }
    }
    @IBOutlet weak var remberMeBtn: UIButton!
    
    //sign up
    //// Validation label
    @IBOutlet weak var phoneNumberLabel:UILabel!
    @IBOutlet weak var firstNameLabel:UILabel!
    @IBOutlet weak var lastNameLabel:UILabel!
    @IBOutlet weak var emailLabel:UILabel!
    @IBOutlet weak var passwordLabel:UILabel!
    @IBOutlet weak var genderLabel:UILabel!
    @IBOutlet weak var dateOFBirthLabel:UILabel!
    @IBOutlet weak var panLabel:UILabel!
    @IBOutlet weak var adharLabel:UILabel!
    @IBOutlet weak var termsLabel:UILabel!
 
    @IBOutlet weak var countryImage: UIImageView! {
        didSet {
            countryImage.image = UIImage(named: AppManager.shared.countryFlag)
        }
    }
    @IBOutlet weak var phoneCodeTextField: UILabel! {
        didSet {
            phoneCodeTextField.text = AppManager.shared.countryCode
        }
    }
    @IBOutlet weak var phoneNumberTextField:UITextField!{
        didSet {
            phoneNumberTextField.delegate = self
            phoneNumberTextField.keyboardType = .numberPad
        }
    }
    @IBOutlet weak var firstNameTextField:UITextField!{
        didSet {
            firstNameTextField.delegate = self
        }
    }
    @IBOutlet weak var lastNameTextField:UITextField!{
        didSet {
            lastNameTextField.delegate = self
        }
    }
    @IBOutlet weak var genderTextField:UITextField!{
        didSet {
            genderTextField.delegate = self
        }
    }
    @IBOutlet weak var dateOfBirthTextField: UITextField!{
        didSet {
            dateOfBirthTextField.delegate = self
        }
    }
    @IBOutlet weak var emailAddressTextField:UITextField!{
        didSet {
            emailAddressTextField.delegate = self
            emailAddressTextField.keyboardType = .emailAddress
        }
    }
    @IBOutlet weak var signUpPasswordTextField:UITextField!{
        didSet {
            signUpPasswordTextField.delegate = self
        }
    }
    @IBOutlet weak var panNumberTextField:UITextField!{
        didSet {
            panNumberTextField.delegate = self
        }
    }
    @IBOutlet weak var adharNumberTextField:UITextField!{
        didSet {
            adharNumberTextField.delegate = self
            adharNumberTextField.keyboardType = .numberPad
        }
    }
    @IBOutlet weak var termsAndPrivacyLabel: UILabel!
    @IBOutlet weak var termsAcceptBtn: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var isSignIn = true
    var isPassTap = false
    var isRememberMeTap = false
    var isTermAccepted = false
    let dropDown = DropDown()
    var datePicker = UIDatePicker()
    var datePickerConstraints = [NSLayoutConstraint]()
    var blurEffectView = UIView()
    var imagePicker = UIImagePickerController()
    var dictSocial = NSDictionary()
    
    // MARK: - Life cycle Functions -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if AppManager.shared.rememberMeEmail != "" {
            loginEmailTextField.text = AppManager.shared.rememberMeEmail
            loginPasswordTextField.text = AppManager.shared.rememberMePassword
            isRememberMeTap = true
            if #available(iOS 13.0, *) {
                remberMeBtn.setImage(UIImage(systemName: "checkmark"), for: .normal)
            }
            remberMeBtn.tintColor = .white
            remberMeBtn.backgroundColor = UIColor(named: "BlueColor")
            remberMeBtn.borderColor = UIColor(named: "BlueColor")
        } else {
            if #available(iOS 13.0, *) {
                remberMeBtn.setImage(UIImage(systemName:""), for: .normal)
                remberMeBtn.tintColor = .systemGray5
                remberMeBtn.backgroundColor = .none
                remberMeBtn.borderColor = .systemGray5
            }
        }
        signUpLineView.isHidden = true
        signUpView.isHidden = true
        dateOfBirthTextField.delegate = self
        self.setDatePicker()
        self.setupDropDown()
        self.signInUIManage()
        self.setSwipeGestureToView()
        setupMultipleTapLabel()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        selectedTabIndex = self.tabBarController?.selectedIndex ?? 0
        
        if !isRememberMeTap {
            loginEmailTextField.text = ""
            loginPasswordTextField.text = ""
        }
    }
    
    //MARK: - Selectors -
    
    // Login and SignUp Button Action
    @IBAction func loginAndSignupButton(_ sender: UIButton){
        self.view.endEditing(true)
        if sender.tag == 1001 {
            isSignIn = true
            signInUIManage()
        }else{
            phoneNumberTextField.becomeFirstResponder()
            isSignIn = false
            signInUIManage()
        }
    }
    
    // Apple Login Button Action
    @IBAction func appleLoginBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.startSignInWithAppleFlow()
    }
    
    // Google Sigin Button Action
    @IBAction func googleLoginButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        GIDSignIn.sharedInstance.signIn(with: GIDConfiguration.init(clientID: myApp.googleClientId), presenting: self) { (userDetail, error) in
            guard error == nil else { return }
            guard let userDetails = userDetail else { return }
            let params: Parameters = [
                "firstName": userDetails.profile?.givenName ?? "",
                "lastName": userDetails.profile?.familyName ?? "",
                "email": userDetails.profile?.email ?? "",
                "googleId": userDetail?.userID ?? "",
                "imageUrl": "\(userDetails.profile?.imageURL(withDimension: 320)?.absoluteString ?? "")",
                "deviceInfo": [
                    "deviceType": "mobile",
                    "appVersion": "27",
                    "deviceToken": (deviceFcmToken ?? "") as String,
                    "deviceData": "\(UIDevice.modelName)"
                ]
            ]
            self.socialLoginApi(params: params)
        }
    }

    // FaceBook Login Button Action
    @IBAction func facebookLoginButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        //Fb login process
        // 1
        let loginManager = LoginManager()
//        loginManager.logOut()
        loginManager.logIn(permissions: ["public_profile", "email"], from: self) { (result, error) in
            guard error == nil else {
                // Error occurred
                print(error!.localizedDescription)
                return
            }
            guard let result = result, !result.isCancelled else {
                print("User cancelled login")
                return
            }
            Profile.loadCurrentProfile { (profile, error) in
                guard let profile = profile else{return}
                let params: Parameters = [
                    "firstName": profile.firstName ?? "",
                    "lastName": profile.lastName ?? "",
                    "email": profile.email ?? "",
                    "googleId": profile.userID,
                    "imageUrl": profile.imageURL?.absoluteString ?? "",
                    "deviceInfo": [
                        "deviceType": "mobile",
                        "appVersion": "27",
                        "deviceToken": (deviceFcmToken ?? "") as String,
                        "deviceData": "\(UIDevice.modelName)"
                    ]
                ]
                self.socialLoginApi(params: params)
                loginManager.logOut()
            }
        }
    }
    
    // Upload Document Button Action
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
    
    // Remember Me Button Action
    @IBAction func rememberMeButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if sender.tag == 1001 {
            isRememberMeTap = !isRememberMeTap
            if #available(iOS 13.0, *) {
                sender.setImage(UIImage(systemName: isRememberMeTap ? "checkmark" : ""), for: .normal)
                sender.tintColor = isRememberMeTap ? .white : .systemGray5
                sender.backgroundColor = isRememberMeTap ? UIColor(named: "BlueColor") : .none
                sender.borderColor = isRememberMeTap ? UIColor(named: "BlueColor") : .systemGray5
            }
        }else{
            isTermAccepted = !isTermAccepted
            if #available(iOS 13.0, *) {
                sender.setImage(UIImage(systemName: isTermAccepted ? "checkmark" : ""), for: .normal)
                sender.tintColor = isTermAccepted ? .white : .systemGray5
                sender.backgroundColor = isTermAccepted ? UIColor(named: "BlueColor") : .none
                sender.borderColor = isTermAccepted ? UIColor(named: "BlueColor") : .systemGray5
                if !isTermAccepted {
                    termsLabel.isHidden = false
                    termsLabel.text =  ValidationManager.shared.sTermAccepted
                }else {
                    termsLabel.isHidden = true
                }
            }
        }
    }
    
    // New Register Button Action
    @IBAction func newRegisterButton(_ sender: UIButton) {
        self.view.endEditing(true)
        isSignIn = false
        signInUIManage()
    }
    
    // Forgot Password Button Action
    @IBAction func forgotPasswordButton(_ sender: UIButton) {
        self.view.endEditing(true)
        let customV = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
        let popup = PopupDialog(viewController: customV, buttonAlignment: .horizontal, transitionStyle: .bounceUp, tapGestureDismissal: true)
        self.present(popup, animated: true, completion: nil)
    }
    
    // Alerady Login Button Action
    @IBAction func alreadyLoginButton(_ sender: UIButton) {
        self.view.endEditing(true)
        isSignIn = true
        signInUIManage()
    }
    
    // Password Toggle Button Action
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
    
    // Phone Code Button Action
    @IBAction func phoneCodeBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)        
        let countriesVC = self.storyboard?.instantiateViewController(withIdentifier: "CountryViewController") as! CountryViewController
        countriesVC.onCompletion = {(code,flag,country) in
            AppManager.shared.countryCode = ""
            AppManager.shared.countryFlag = ""
            if let url = URL(string: flag) {
                self.countryImage.sd_setImage(with: url, completed: nil)
            }
            self.phoneCodeTextField.text = code
            
        }
        let navC = UINavigationController.init(rootViewController: countriesVC)
        self.present(navC, animated: true, completion: nil)
        
    }
    
    // Drop Down Button Action
    @IBAction func dropdownButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        dropDown.show()
    }
    
    
    // Login Button Action
    @IBAction func loginButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if isRememberMeTap {
            AppManager.shared.rememberMeEmail = loginEmailTextField.text ?? ""
            AppManager.shared.rememberMePassword = loginPasswordTextField.text ?? ""
        }
        if loginValidation() {
            self.loginApi()
        }        
    }
    
    // SignUp Button Action
    @IBAction func signupButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if signupValidation() {
            self.signUpApi()
        }
    }
    
    // Swipe Gesture  Action
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
    
    // Label Action
    @objc func tapLabel(gesture: UITapGestureRecognizer) {
        self.view.endEditing(true)
        if gesture.didTapAttributedTextInLabel(label: termsAndPrivacyLabel, targetText: "Terms of Use") {
            print("Terms of Use")
            let newVC = self.storyboard?.instantiateViewController(withIdentifier: "StaticContentViewController") as! StaticContentViewController
            newVC.titleLabel = "TERM & CONDITIONS"
            newVC.type = 3
            self.navigationController?.pushViewController(newVC, animated: true)
        } else if gesture.didTapAttributedTextInLabel(label: termsAndPrivacyLabel, targetText: "Privacy Policy") {
            print("Privacy Policy")
            let newVC = self.storyboard?.instantiateViewController(withIdentifier: "StaticContentViewController") as! StaticContentViewController
            newVC.titleLabel = "PRIVACY POLICY"
            newVC.type = 2
            self.navigationController?.pushViewController(newVC, animated: true)
        }
    }
    
    //    MARK: - Helper Functions -
    
    // Sign In With Apple Flow
    func startSignInWithAppleFlow() {
        if #available(iOS 13.0, *) {
            let provider = ASAuthorizationAppleIDProvider()
            let request = provider.createRequest()
            request.requestedScopes = [.fullName,.email]
            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.presentationContextProvider = self
            controller.performRequests()
        } else {
            // Fallback on earlier versions
        }
    }
    
    // SetUp Drop Down
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
    
    
    // Sign In UI Manage
    func signInUIManage(){
        // login and Signup Manage
        self.view.endEditing(true)
        signUpView.isHidden = isSignIn
        loginView.isHidden = !isSignIn
        signUpLineView.isHidden = isSignIn
        loginLineView.isHidden = !isSignIn
        loginButton.setTitleColor((isSignIn) ? UIColor.init(hexFromString: "#2878B6") : UIColor.darkGray, for: .normal)
        signUpButton.setTitleColor((!isSignIn) ? UIColor.init(hexFromString: "#2878B6") : UIColor.darkGray, for: .normal)
        
//        // login
//        userNameTextField.text = nil
//        loginPasswordTextField.text = nil
        
        // Signup
        phoneNumberTextField.text = nil
        firstNameTextField.text = nil
        lastNameTextField.text = nil
        emailAddressTextField.text = nil
        signUpPasswordTextField.text = nil
        dateOfBirthTextField.text = nil
        genderTextField.text = nil
        panNumberTextField.text = nil
        adharNumberTextField.text = nil
    }
    
    func setSwipeGestureToView() {
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
    }
        
    // Tap Label SetUp
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
    
    func setDatePicker() {
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Ok", style: .plain, target: self, action: #selector(dobTxtFieldDoneDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        dateOfBirthTextField.inputAccessoryView = toolbar
        dateOfBirthTextField.inputView = datePicker
    }
    // DOBTextField DatePicker Done Button Action
    @objc func dobTxtFieldDoneDatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        dateOfBirthTextField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    // Date Picker Cancel Button Action
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    // Open Camera
    func openCamera(){
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
    
    // Open Photo Gallary
    func openPhotos(){
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    // Login Validation
    func loginValidation() -> Bool {
        var isValidate = true
        if loginEmailTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
            loginEmailLabel.isHidden = false
            loginEmailLabel.text =  ValidationManager.shared.lEmail
            isValidate = false
        } else if !isValidEmail(loginEmailTextField.text ?? "") {
            loginEmailLabel.isHidden = false
            loginEmailLabel.text =  ValidationManager.shared.sEmailInvalid
            isValidate = false
        } else {
            loginEmailLabel.isHidden = true
        }
        
        if loginPasswordTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
            loginPasswordLabel.isHidden = false
            loginPasswordLabel.text =  ValidationManager.shared.sPassword
            isValidate = false
        } else {
            loginPasswordLabel.isHidden = true
        }
        return isValidate
    }
    
    // Sign Up Validation
    func signupValidation() -> Bool {
        var isValidate = true
        if phoneNumberTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
            phoneNumberLabel.isHidden = false
            phoneNumberLabel.text =  ValidationManager.shared.sPhoneNumber
            isValidate = false
        } else if !isValidMobileNumber(mobileNumber: phoneNumberTextField.text ?? "") {
            phoneNumberLabel.isHidden = false
            phoneNumberLabel.text =  ValidationManager.shared.sPhoneNumber
            isValidate = false
        }
        else {
            phoneNumberLabel.isHidden = true
        }
        
        if firstNameTextField.text?.trimmingCharacters(in: .whitespaces).count ?? 0 < 3 {
            firstNameLabel.isHidden = false
            firstNameLabel.text =  ValidationManager.shared.sFirstName
            isValidate = false
        } else {
            firstNameLabel.isHidden = true
        }
    
        if lastNameTextField.text?.trimmingCharacters(in: .whitespaces).count ?? 0 < 3 {
            lastNameLabel.isHidden = false
            lastNameLabel.text =  ValidationManager.shared.sLastName
            isValidate = false
        } else {
            lastNameLabel.isHidden = true
        }
        
        if emailAddressTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
            emailLabel.isHidden = false
            emailLabel.text =  ValidationManager.shared.sEmail
            isValidate = false
        } else if !isValidEmail(emailAddressTextField.text ?? "") {
            emailLabel.isHidden = false
            emailLabel.text =  ValidationManager.shared.sEmailInvalid
            isValidate = false
        }
        else {
            emailLabel.isHidden = true
        }

        if signUpPasswordTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
            passwordLabel.isHidden = false
            passwordLabel.text =  ValidationManager.shared.sPassword
            isValidate = false
        } else if !isValidPassword(mypassword: signUpPasswordTextField.text ?? "") {
            passwordLabel.isHidden = false
            passwordLabel.text =  ValidationManager.shared.sPassword
            isValidate = false
        }
        else {
            passwordLabel.isHidden = true
        }
        
        if genderTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
            genderLabel.isHidden = false
            genderLabel.text =  ValidationManager.shared.sGender
            isValidate = false
        } else {
            genderLabel.isHidden = true
        }
        
        if dateOfBirthTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
            dateOFBirthLabel.isHidden = false
            dateOFBirthLabel.text =  ValidationManager.shared.sDateOfBirth
            isValidate = false
        } else {
            dateOFBirthLabel.isHidden = true
        }
      
        if panNumberTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
            panLabel.isHidden = false
            panLabel.text =  ValidationManager.shared.sPanCard
            isValidate = false
        } else {
            panLabel.isHidden = true
        }
        
        if adharNumberTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
            adharLabel.isHidden = false
            adharLabel.text =  ValidationManager.shared.sAdharCard
            isValidate = false
        } else {
            adharLabel.isHidden = true
        }
        
        if !isTermAccepted {
            termsLabel.isHidden = false
            termsLabel.text =  ValidationManager.shared.sTermAccepted
            isValidate = false
        }else {
            termsLabel.isHidden = true
        }
        return isValidate
    }
    
}


// MARK: - Extensions -

//MARK: API Call
extension LoginViewController {
    
    //LogIn Api
    func loginApi() {
        let params: Parameters = [
            "email": "\(loginEmailTextField.text ?? "")",
            "password": "\(loginPasswordTextField.text ?? "")",
            "deviceInfo": [
                "deviceType":"mobile" as String,
                "appVersion":"27" as String,
                "deviceToken":(deviceFcmToken ?? "") as String,
                "deviceData":"\(UIDevice.modelName)"
            ]
        ]
        showLoading()
        APIHelper.loginUser(params: params) { (success,response)  in
            if !success {
                dissmissLoader()
                let message = response.message
                print(message)
                self.view.makeToast(message)
            }else {
                dissmissLoader()
                let data = response.response["data"]
                user = User.init(json: data)
                AppManager.shared.token = user?.access_token ?? ""
                AppManager.shared.userId = user?.id ?? ""
                //                AppUserDefaults.saveObject(self.user?.access_token, forKey: .userAuthToken)
                let newVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeNav") as! UINavigationController
                myApp.window?.rootViewController = newVC
                let message = response.message
                print(message)
                myApp.window?.rootViewController?.view.makeToast(message)
            }
        }
    }
    
    //SignUp Api
    func signUpApi() {
        let params: Parameters = [
            "email":"\(emailAddressTextField.text ?? "")",
            "extensionNumber":"\(phoneCodeTextField.text ?? "")",
            "contactNumber":"\(phoneNumberTextField.text ?? "")",
            "password":"\(signUpPasswordTextField.text ?? "")",
            "gender":"\(genderTextField.text ?? "")",
            "firstName":"\(firstNameTextField.text ?? "")",
            "lastName":"\(lastNameTextField.text ?? "")",
            "dateOfBirth":"\(dateOfBirthTextField.text ?? "")",
            "panNumber": "\(panNumberTextField.text ?? "")",
            "aadharNumber": "\(adharNumberTextField.text ?? "")",
            "deviceInfo": [
                "deviceType":"mobile" as String,
                "appVersion":"27" as String,
                "deviceToken":(deviceFcmToken ?? "") as String,
                "deviceData":"\(UIDevice.modelName)"
            ]
        ]
        print(params)
        showLoading()
        APIHelper.registerUser(params: params) { (success,response)  in
            if !success {
                dissmissLoader()
                let message = response.message
                print(message)
                self.view.makeToast(message)
            }else {
                dissmissLoader()
                self.isSignIn = true
                self.signInUIManage()
                let message = response.message
                print(message)
                self.view.makeToast(message)
            }
        }
    }
    
    // Social Login Api
    func socialLoginApi(params: Parameters) {
        showLoading()
        APIHelper.socialLoginApi(params: params) { (success,response)  in
            if !success {
                dissmissLoader()
                let message = response.message
                print(message)
                self.view.makeToast(message)
            }else {
                dissmissLoader()
                let data = response.response["data"]
                user = User.init(json: data)
                AppManager.shared.token = user?.access_token ?? ""
                AppManager.shared.userId = user?.id ?? ""
                //                AppUserDefaults.saveObject(self.user?.access_token, forKey: .userAuthToken)
                let newVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeNav") as! UINavigationController
                myApp.window?.rootViewController = newVC
                let message = response.message
                print(message)
                GIDSignIn.sharedInstance.signOut()
                
            }
        }
    }
}

//MARK: Image Picker Delegate Methods
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

//MARK: UI Tap Gesture SetUp For Label
extension UITapGestureRecognizer {
    
    // Set tap Gesture To Attributed Text Label
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

//MARK: Text Field Delegate Methods
extension LoginViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        switch textField {
        case loginEmailTextField:
            if loginEmailTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
                loginEmailLabel.isHidden = false
                loginEmailLabel.text =  ValidationManager.shared.lEmail
            } else if !isValidEmail(loginEmailTextField.text ?? "") {
                loginEmailLabel.isHidden = false
                loginEmailLabel.text =  ValidationManager.shared.sEmailInvalid
            } else {
                loginEmailLabel.isHidden = true
            }
        case loginPasswordTextField :
            if loginPasswordTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
                loginPasswordLabel.isHidden = false
                loginPasswordLabel.text =  ValidationManager.shared.sPassword
            } else {
                loginPasswordLabel.isHidden = true
            }
        case phoneNumberTextField:
            if phoneNumberTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
                phoneNumberLabel.isHidden = false
                phoneNumberLabel.text =  ValidationManager.shared.sPhoneNumber
                
            } else if !isValidMobileNumber(mobileNumber: phoneNumberTextField.text ?? "") {
                phoneNumberLabel.isHidden = false
                phoneNumberLabel.text =  ValidationManager.shared.sPhoneNumber
            }
            else {
                phoneNumberLabel.isHidden = true
            }
        case firstNameTextField:
            if firstNameTextField.text?.trimmingCharacters(in: .whitespaces).count ?? 0 < 3 {
                firstNameLabel.isHidden = false
                firstNameLabel.text =  ValidationManager.shared.sFirstName
            } else {
                firstNameLabel.isHidden = true
            }
        case lastNameTextField:
            if lastNameTextField.text?.trimmingCharacters(in: .whitespaces).count ?? 0 < 3 {
                lastNameLabel.isHidden = false
                lastNameLabel.text =  ValidationManager.shared.sLastName
            } else {
                lastNameLabel.isHidden = true
            }
            
        case emailAddressTextField:
            if emailAddressTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
                emailLabel.isHidden = false
                emailLabel.text =  ValidationManager.shared.sEmail
            } else if !isValidEmail(emailAddressTextField.text ?? "") {
                emailLabel.isHidden = false
                emailLabel.text =  ValidationManager.shared.sEmailInvalid
            }
            else {
                emailLabel.isHidden = true
            }
            
        case signUpPasswordTextField:
            if signUpPasswordTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
                passwordLabel.isHidden = false
                passwordLabel.text =  ValidationManager.shared.emptyPassword
            } else if !isValidPassword(mypassword: signUpPasswordTextField.text ?? "") {
                passwordLabel.isHidden = false
                passwordLabel.text =  ValidationManager.shared.sPassword
            }
            else {
                passwordLabel.isHidden = true
            }
            
        case genderTextField:
            if genderTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
                genderLabel.isHidden = false
                genderLabel.text =  ValidationManager.shared.sGender
            } else {
                genderLabel.isHidden = true
            }
            
        case dateOfBirthTextField:
            if dateOfBirthTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
                dateOFBirthLabel.isHidden = false
                dateOFBirthLabel.text =  ValidationManager.shared.sDateOfBirth
            } else {
                dateOFBirthLabel.isHidden = true
            }            
        case panNumberTextField:
            if !isValidPanNumber(adhar: panNumberTextField.text ?? ""){
                panLabel.isHidden = false
                panLabel.text =  ValidationManager.shared.sPanCard
            } else {
                panLabel.isHidden = true
            }
        case adharNumberTextField:
           if !isValidAdharNumber(adhar: adharNumberTextField.text ?? "") {
                adharLabel.isHidden = false
                adharLabel.text =  ValidationManager.shared.sAdharCard
            }
            else {
                adharLabel.isHidden = true
            }
        default:
            break
        }
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

//MARK: ASAuthorizationControllerDelegate Methods
@available(iOS 13.0, *)
extension LoginViewController: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            let keychain = KeychainSwift()
            // Create an account in your system.
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            var firstName = ""
            var lastName = ""
            var strEmail = ""
            if let fName = fullName?.givenName {
                firstName = fName
                keychain.set(fName, forKey: "applFName")
            } else {
                if let fName = keychain.get("applFName") {
                    firstName = fName
                }
            }
            if let lName = fullName?.familyName {
                lastName = lName
                keychain.set(lName, forKey: "applLName")
            } else {
                if let lName = keychain.get("applLName") {
                    lastName = lName
                }
            }
            if let email = appleIDCredential.email {
                strEmail = email
                keychain.set(email, forKey: "applEmail")
            } else {
                if let email = keychain.get("applEmail") {
                    strEmail = email
                }
            }
            if let email = appleIDCredential.email {
                strEmail = email
                self.dictSocial = NSDictionary.init(dictionary: ["id": userIdentifier,"email":email,"first_name":firstName,"last_name":lastName])
            } else {
                self.dictSocial = NSDictionary.init(dictionary: ["id": userIdentifier,"first_name":firstName,"last_name":lastName])
            }
            let params: Parameters = [
                "firstName": firstName,
                "lastName": lastName,
                "email": strEmail,
                "googleId": userIdentifier,
                "imageUrl": "",
                "deviceInfo": [
                    "deviceType": "mobile",
                    "appVersion": "27",
                    "deviceToken": (deviceFcmToken ?? "") as String,
                    "deviceData": "\(UIDevice.modelName)"
                ]
            ]
            self.socialLoginApi(params: params)
            
        case let passwordCredential as ASPasswordCredential:
            // Sign in using an existing iCloud Keychain credential.
            _ = passwordCredential.user
            _ = passwordCredential.password
        default:
            break
        }
    }
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error.localizedDescription)
    }
    
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
