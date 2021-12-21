//
//  ForgotPasswordViewController.swift
//  Actorpay
//
//  Created by iMac on 09/12/21.
//

import UIKit
import Alamofire

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var forgotPasswordView: UIView!
    @IBOutlet weak var forgotPasswordLabelView: UIView!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topCorners(bgView: forgotPasswordLabelView, cornerRadius: 10, maskToBounds: true)
        bottomCorner(bgView: buttonView, cornerRadius: 10, maskToBounds: true)
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        self.showAnimate()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func showAnimate(){
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate(){
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished){
                self.view.removeFromSuperview()
            }
        });
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(touches.first?.view != forgotPasswordView){
            removeAnimate()
        }
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton){
        removeAnimate()
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func okButtonAction(_ sender: UIButton){
        
        if emailTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            self.view.makeToast("Please Enter an Email Address.")
            return
        }
        
        if !isValidEmail(emailTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""){
            self.alertViewController(message: "Please enter a valid Email ID.")
            return
        }
        
        let params: Parameters = [
            "emailId": "\(emailTextField.text ?? "")"
        ]
        startActivityIndicator()
        APIHelper.forgotPassword(params: params) { (success,response)  in
            if !success {
                stopActivityIndicator()
                let message = response.message
                myApp.window?.rootViewController?.view.makeToast(message)
            }else {
                stopActivityIndicator()
                let message = response.message
                myApp.window?.rootViewController?.view.makeToast(message)
                self.removeAnimate()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
