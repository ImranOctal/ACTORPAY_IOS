//
//  ProfileViewController.swift
//  Actorpay
//
//  Created by iMac on 03/12/21.
//

import UIKit
import Alamofire

var isProfileView = false

class ProfileViewController: UIViewController {
    
    //MARK: - Prope

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topCorner(bgView: mainView, maskToBounds: true)
        setupUserData()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupUserData()
        self.navigationController?.navigationBar.isHidden = true
    }
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
    
    @IBAction func saveButtonAction(_ sender: UIButton) {
        // Validation
        if nameTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            self.view.makeToast( "Please Enter a last name.")
            return
        }
        
        if emailTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            self.view.makeToast( "Please Enter an email.")
            return
        }
        
        if !isValidEmail(emailTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""){
            self.view.makeToast( "Please enter a valid Email ID.")
            return
        }
        
        if phoneNumberTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            self.view.makeToast( "Please Enter a phone number.")
            return
        }
        
        self.view.endEditing(true)
        
        let params: Parameters = [
            "username": "\(nameTextField.text ?? "")",
            "extensionNumber":"+91",
            "contactNumber":"\(phoneNumberTextField.text ?? "")",
            "email": "\(emailTextField.text ?? "")",
            "id":"\(AppManager.shared.userId)"
        ]
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
            }
        }        
    }
    
    //    MARK: - helper Functions -
    
    func setupUserData() {
        nameTextField.text = (user?.firstName ?? "") + (user?.lastName ?? "")
        emailTextField.text = user?.email ?? ""
        phoneNumberTextField.text = (user?.extensionNumber ?? "")+(user?.contactNumber ?? "")
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
