//
//  ProfileViewController.swift
//  Actorpay
//
//  Created by iMac on 03/12/21.
//

import UIKit
import Alamofire
import SDWebImage
import DropDown
import PopupDialog

var isProfileView = false

class ProfileViewController: UIViewController {
    
    //MARK: - Properties -
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var phoneCodeTextField: UILabel!
    @IBOutlet weak var countryImage: UIImageView!
    @IBOutlet weak var nameTextField: UITextField! {
        didSet {
            nameTextField.delegate = self
        }
    }
    @IBOutlet weak var genderTextField: UITextField! {
        didSet {
            genderTextField.delegate = self
        }
    }
    @IBOutlet weak var dobTextField: UITextField! {
        didSet {
            dobTextField.delegate = self
        }
    }
    @IBOutlet weak var emailTextField: UITextField! {
        didSet {
            emailTextField.delegate = self
        }
    }
    @IBOutlet weak var phoneNumberTextField: UITextField! {
        didSet {
            phoneNumberTextField.delegate = self
        }
    }
    @IBOutlet weak var panNoTextField: UITextField! {
        didSet {
            panNoTextField.delegate = self
        }
    }
    @IBOutlet weak var aadharNoTextField: UITextField! {
        didSet {
            aadharNoTextField.delegate = self
        }
    }
    @IBOutlet weak var nameValidationLbl: UILabel!
    @IBOutlet weak var genderValidationLbl: UILabel!
    @IBOutlet weak var dobValidationLbl: UILabel!
    @IBOutlet weak var emailValidationLbl: UILabel!
    @IBOutlet weak var phoneNoValidationLbl: UILabel!
    @IBOutlet weak var panNoValidationLbl: UILabel!
    @IBOutlet weak var aadharNoValidationLbl: UILabel!
    @IBOutlet weak var emailVerifyButton: UIButton!
    @IBOutlet weak var phoneVerifyButton: UIButton!
    
    var imagePicker = UIImagePickerController()
    let dropDown = DropDown()
    var datePicker = UIDatePicker()
    var blurEffectView = UIView()
    
    //MARK: - Life Cycles -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.manageValidationLbl()
        topCorner(bgView: mainView, maskToBounds: true)
        self.setupUserData()
        NotificationCenter.default.removeObserver(self, name: Notification.Name("setupUserData"), object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(self.setupUserData),name:Notification.Name("setupUserData"), object: nil)
        self.setDatePicker()
        self.setupDropDown()
        self.emailVarifyFlow()
        self.mobileVerifyButtonFlow()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: - Selectors -
    
    // Edit Image Button Action
    @IBAction func editImageButton(_ sender: UIButton) {
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
    
    // Verify Email Button Action
    @IBAction func verifyEmailButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if sender.currentTitle == "UPDATE" {
//            emailTextField.isUserInteractionEnabled = true
//            emailTextField.textColor = UIColor.black
//            emailValidationLbl.textColor = UIColor.orange
//            emailValidationLbl.text = "Verification Pending"
//            emailVerifyButton.setTitle("Verify", for: .normal)
            let customV = self.storyboard?.instantiateViewController(withIdentifier: "VerifyViewController") as! VerifyViewController
            let popup = PopupDialog(viewController: customV, buttonAlignment: .horizontal, transitionStyle: .bounceUp, tapGestureDismissal: true)
            customV.isEmailVerify = true
            self.present(popup, animated: true, completion: nil)
        } else {
            let customV = self.storyboard?.instantiateViewController(withIdentifier: "VerifyOTPViewController") as! VerifyOTPViewController
            let popup = PopupDialog(viewController: customV, buttonAlignment: .horizontal, transitionStyle: .bounceUp, tapGestureDismissal: true)
            self.present(popup, animated: true, completion: nil)
        }
        self.setupUserData()
    }
    
    // Verify Phone Number Button Action
    @IBAction func verifyPhoneButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if sender.currentTitle == "UPDATE" {
//            phoneNumberTextField.isUserInteractionEnabled = true
//            phoneNumberTextField.textColor = UIColor .black
//            phoneNoValidationLbl.text = "Verification Pending"
//            phoneNoValidationLbl.textColor = UIColor.orange
//            phoneVerifyButton.setTitle("Verify", for: .normal)
            let customV = self.storyboard?.instantiateViewController(withIdentifier: "VerifyViewController") as! VerifyViewController
            let popup = PopupDialog(viewController: customV, buttonAlignment: .horizontal, transitionStyle: .bounceUp, tapGestureDismissal: true)
            customV.isEmailVerify = false
            self.present(popup, animated: true, completion: nil)
        } else {
            if !(user?.phoneVerified ?? false){
                sendOTPRequestAPI()
            }else{
                self.view.makeToast("Phone Number Already Verified!.")
            }
//            let newVC = self.storyboard?.instantiateViewController(withIdentifier: "VerifyOTPViewController") as! VerifyOTPViewController
//            newVC.view.backgroundColor = UIColor(white: 0, alpha: 0.5)
//            self.definesPresentationContext = true
//            self.providesPresentationContextTransitionStyle = true
//            newVC.modalPresentationStyle = .overCurrentContext
//            self.navigationController?.present(newVC, animated: true, completion: nil)
        }
        self.setupUserData()
    }
    
    // Phone Code Button Action
    @IBAction func phoneCodeBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let countriesVC = self.storyboard?.instantiateViewController(withIdentifier: "CountryViewController") as! CountryViewController
        countriesVC.onCompletion = {(code,flag,country) in
            AppManager.shared.countryCode = ""
            AppManager.shared.countryFlag = ""
            self.countryImage.sd_setImage(with: URL(string: flag), placeholderImage: UIImage(named: "IN.png"), options: SDWebImageOptions.allowInvalidSSLCertificates, completed: nil)
            self.phoneCodeTextField.text = code
            
        }
        let navC = UINavigationController.init(rootViewController: countriesVC)
        self.present(navC, animated: true, completion: nil)
        
    }
    
    // Save Button Action
    @IBAction func saveButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if profileValidation() {
            self.manageValidationLbl()
            self.updateUserProfileApi()
        }
    }
    
    //Gender Button Action
    @IBAction func genderButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        dropDown.show()
    }
    
    // Show Calender Button Action
    @IBAction func showCalender(_ sender: UIButton) {
        self.view.endEditing(true)
//        showDatePicker()
    }
    
    //    MARK: - helper Functions -
    
    // Validation Label Manage
    func manageValidationLbl() {
        nameValidationLbl.isHidden = true
        genderValidationLbl.isHidden = true
        dobValidationLbl.isHidden = true
        panNoValidationLbl.isHidden = true
        aadharNoValidationLbl.isHidden = true
    }
    
    // Profile Validation
    func profileValidation() -> Bool {
        var isValidate = true
        
        if nameTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            nameValidationLbl.isHidden = false
            nameValidationLbl.text = ValidationManager.shared.sFirstName
            isValidate = false
        } else {
            nameValidationLbl.isHidden = true
        }
        
        if genderTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            genderValidationLbl.isHidden = false
            genderValidationLbl.text = ValidationManager.shared.sGender
            isValidate = false
        } else {
            genderValidationLbl.isHidden = true
        }
        
        if dobTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            dobValidationLbl.isHidden = false
            dobValidationLbl.text = ValidationManager.shared.sDateOfBirth
            isValidate = false
        } else {
            dobValidationLbl.isHidden = true
        }
        
        if emailTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            emailValidationLbl.textColor = .red
            emailValidationLbl.text = ValidationManager.shared.lEmail
            isValidate = false
        } else if !isValidEmail(emailTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""){
            emailValidationLbl.textColor = .red
            emailValidationLbl.text = ValidationManager.shared.sEmailInvalid
            isValidate = false
        } else {
            emailVarifyFlow()
        }
        
        if phoneNumberTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            phoneNoValidationLbl.textColor = UIColor.red
            phoneNoValidationLbl.text = ValidationManager.shared.emptyPhone
            isValidate = false
        } else if !isValidMobileNumber(mobileNumber: phoneNumberTextField.text ?? "") {
            phoneNoValidationLbl.textColor = UIColor.red
            phoneNoValidationLbl.text = ValidationManager.shared.validPhone
            isValidate = false
        } else {
            mobileVerifyButtonFlow()
        }
        
        if !isValidPanNumber(adhar: panNoTextField.text ?? ""){
            panNoValidationLbl.isHidden = false
            panNoValidationLbl.text =  ValidationManager.shared.sPanCard
            isValidate = false
        } else {
            panNoValidationLbl.isHidden = true
        }
        
        if !isValidAdharNumber(adhar: aadharNoTextField.text ?? "") {
            aadharNoValidationLbl.isHidden = false
            aadharNoValidationLbl.text =  ValidationManager.shared.sAdharCard
            isValidate = false
        }
        else {
            aadharNoValidationLbl.isHidden = true
        }
        return isValidate
    }
    
    // Set User Data
    @objc func setupUserData() {
        nameTextField.text = (user?.firstName ?? "") + " " + (user?.lastName ?? "")
        genderTextField.text = user?.gender ?? ""
        dobTextField.text = user?.dateOfBirth?.toFormatedDate(from: "yyyy-MM-dd", to: "dd-MM-yyyy")
        emailTextField.text = user?.email ?? ""
        phoneNumberTextField.text = (user?.contactNumber ?? "")
        phoneCodeTextField.text = (user?.extensionNumber ?? "")
        panNoTextField.text = (user?.panNumber ?? "")
        aadharNoTextField.text = (user?.aadharNumber ?? "")
        countryImage.image = UIImage(named: AppManager.shared.countryFlag)
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
    
    // Email Verify Button Flow
    func emailVarifyFlow() {
        if (user?.emailVerified ?? false) {
            emailTextField.isUserInteractionEnabled = false
            emailTextField.textColor = UIColor.darkGray
            emailValidationLbl.text = "Verified"
            emailValidationLbl.textColor = UIColor.init(hexFromString: "2878B6")
            emailVerifyButton.setTitle("UPDATE", for: .normal)
        } else {
            emailTextField.isUserInteractionEnabled = true
            emailTextField.textColor = UIColor.black
            emailValidationLbl.textColor = UIColor.orange
            emailValidationLbl.text = "Verification Pending"
            emailVerifyButton.setTitle("Verify", for: .normal)
        }
    }
    
    // SetUp Mobile No Verify Button
    func mobileVerifyButtonFlow() {
        if user?.phoneVerified ?? true {
            phoneNumberTextField.isUserInteractionEnabled = false
            phoneNumberTextField.textColor = UIColor .darkGray
            phoneNoValidationLbl.text = "Verified"
            phoneNoValidationLbl.textColor = UIColor.init(hexFromString: "2878B6")
            phoneVerifyButton.setTitle("UPDATE", for: .normal)
        } else {
            phoneNumberTextField.isUserInteractionEnabled = true
            phoneNumberTextField.textColor = UIColor .black
            phoneNoValidationLbl.text = "Verification Pending"
            phoneNoValidationLbl.textColor = UIColor.orange
            phoneVerifyButton.setTitle("Verify", for: .normal)
        }
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
    
    // Send Otp Request Api
    func sendOTPRequestAPI() {
        APIHelper.getOTPRequestAPI { (success, response) in
            if !success {
                dissmissLoader()
                let message = response.message
                myApp.window?.rootViewController?.view.makeToast(message)
            }else {
                dissmissLoader()
                let data = response.response["data"]
                if let otp = data.rawValue as? String {
                    print(otp)
                    self.view.makeToast(otp)
                    let customV = self.storyboard?.instantiateViewController(withIdentifier: "VerifyOTPViewController") as! VerifyOTPViewController
                    let popup = PopupDialog(viewController: customV, buttonAlignment: .horizontal, transitionStyle: .bounceUp, tapGestureDismissal: true)
                    customV.onCompletion = {(success) in
                        if success {
                            NotificationCenter.default.post(name:  Notification.Name("getUserDetail"), object: self)
                            self.emailVarifyFlow()
                            self.mobileVerifyButtonFlow()
                        }
                    }
                    self.present(popup, animated: true, completion: nil)
                }
            }
        }
    }
    
    func setDatePicker() {
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Ok", style: .plain, target: self, action: #selector(fromTxtFieldDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        dobTextField.inputAccessoryView = toolbar
        dobTextField.inputView = datePicker
    }
    // FromTextField DatePicker Done Button Action
    @objc func fromTxtFieldDatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        dobTextField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    // Date Picker Cancel Button Action
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    
    //Open Photo Gallary
    func openPhotos(){
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
    }
}


// MARK: - Extensions -

//MARK: Api Call
extension ProfileViewController {
    // Update User Profile Api
    func updateUserProfileApi() {
        let params: Parameters = [
            "username": "\(nameTextField.text ?? "")",
            "extensionNumber":"\(phoneCodeTextField.text ?? "")",
            "contactNumber":"\(phoneNumberTextField.text ?? "")",
            "email": "\(emailTextField.text ?? "")",
            "dateOfBirth":"\(dobTextField.text ?? "")",
            "id":"\(AppManager.shared.userId)",
            "panNumber": "\(panNoTextField.text ?? "")",
            "aadharNumber": "\(aadharNoTextField.text ?? "")"
        ]
        print(params)
        showLoading()
        APIHelper.updateUser(params: params) { (success,response)  in
            if !success {
                dissmissLoader()
                let message = response.message
                myApp.window?.rootViewController?.view.makeToast(message)
            }else {
                dissmissLoader()
                let message = response.message
                myApp.window?.rootViewController?.view.makeToast(message)
                NotificationCenter.default.post(name:  Notification.Name("getUserDetail"), object: self)
                self.emailVarifyFlow()
                self.mobileVerifyButtonFlow()
            }
        }
    }
}

//MARK: Image Picker Delegate Methods
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage{
            userImageView.image = image
        }
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

//MARK: TextField Delegate Methods
extension ProfileViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        switch textField {
        case nameTextField:
            if nameTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
                nameValidationLbl.isHidden = false
                nameValidationLbl.text = ValidationManager.shared.sFirstName
            } else {
                nameValidationLbl.isHidden = true
            }
        case genderTextField:
            if genderTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
                genderValidationLbl.isHidden = false
                genderValidationLbl.text = ValidationManager.shared.sGender
            } else {
                genderValidationLbl.isHidden = true
            }
        case dobTextField:
            if dobTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
                dobValidationLbl.isHidden = false
                dobValidationLbl.text = ValidationManager.shared.sDateOfBirth
            } else {
                dobValidationLbl.isHidden = true
            }
        case emailTextField:
            if emailTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
                emailValidationLbl.textColor = .red
                emailValidationLbl.text = ValidationManager.shared.lEmail
            } else if !isValidEmail(emailTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""){
                emailValidationLbl.textColor = .red
                emailValidationLbl.text = ValidationManager.shared.sEmailInvalid
            } else {
                emailValidationLbl.textColor = UIColor.orange
                emailValidationLbl.text = "Varification Pending"
            }
        case phoneNumberTextField:
            if phoneNumberTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
                phoneNoValidationLbl.textColor = UIColor.red
                phoneNoValidationLbl.text = ValidationManager.shared.emptyPhone
            } else if !isValidMobileNumber(mobileNumber: phoneNumberTextField.text ?? "") {
                phoneNoValidationLbl.textColor = UIColor.red
                phoneNoValidationLbl.text = ValidationManager.shared.validPhone
            } else {
                phoneNoValidationLbl.textColor = UIColor.orange
                phoneNoValidationLbl.text = "Varification Pending"
            }
        case panNoTextField:
            if !isValidPanNumber(adhar: panNoTextField.text ?? ""){
                panNoValidationLbl.isHidden = false
                panNoValidationLbl.text =  ValidationManager.shared.sPanCard
            } else {
                panNoValidationLbl.isHidden = true
            }
        case aadharNoTextField:
            if !isValidAdharNumber(adhar: aadharNoTextField.text ?? "") {
                aadharNoValidationLbl.isHidden = false
                aadharNoValidationLbl.text =  ValidationManager.shared.sAdharCard
            }
            else {
                aadharNoValidationLbl.isHidden = true
            }
            
        default:
            break
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
