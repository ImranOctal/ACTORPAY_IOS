//
//  VerifyOTPViewController.swift
//  Actorpay
//
//  Created by iMac on 07/01/22.
//

import UIKit
import Alamofire

class VerifyOTPViewController: UIViewController {
    
    //MARK: - Properties -

    @IBOutlet weak var firstCodeTxtField: UITextField! {
        didSet {
            firstCodeTxtField.delegate = self
        }
    }
    @IBOutlet weak var secondCodeTxtField: UITextField! {
        didSet {
            secondCodeTxtField.delegate = self
        }
    }
    @IBOutlet weak var thirdCodeTxtField: UITextField! {
        didSet {
            thirdCodeTxtField.delegate = self
        }
    }
    @IBOutlet weak var fourthCodeTxtField: UITextField! {
        didSet {
            fourthCodeTxtField.delegate = self
        }
    }
    @IBOutlet weak var fifthCodeTxtField: UITextField! {
        didSet {
            fifthCodeTxtField.delegate = self
        }
    }
    @IBOutlet weak var sixthCodeTxtField: UITextField! {
        didSet {
            sixthCodeTxtField.delegate = self
        }
    }
    
    typealias CompletionBlock = (_ success: Bool) -> Void
    var onCompletion:CompletionBlock?
    var isEmail = false
    
    //MARK: - Life Cycles -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print(isEmail)
    }
    
    //MARK: - Selectors -
    
    // OK Button Action
    @IBAction func okButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let first = firstCodeTxtField.text?.trimmingCharacters(in: .whitespaces).count ?? 0
        let second = secondCodeTxtField.text?.trimmingCharacters(in: .whitespaces).count ?? 0
        let third = thirdCodeTxtField.text?.trimmingCharacters(in: .whitespaces).count ?? 0
        let four = fourthCodeTxtField.text?.trimmingCharacters(in: .whitespaces).count ?? 0
        let fifth = fifthCodeTxtField.text?.trimmingCharacters(in: .whitespaces).count ?? 0
        let sixth = sixthCodeTxtField.text?.trimmingCharacters(in: .whitespaces).count ?? 0
        if (first == 0 || second == 0 || third == 0 || four == 0 || fifth == 0 || sixth == 0){
            self.view.makeToast("Please enter an OTP code", duration: 3.0, position: .bottom)
            return
        }
        let otp = (firstCodeTxtField.text ?? "")+(secondCodeTxtField.text ?? "")+(thirdCodeTxtField.text ?? "")
        let otp2 = (fourthCodeTxtField.text ?? "")+(fifthCodeTxtField.text ?? "")+(sixthCodeTxtField.text ?? "")
        let finalOTP = otp + otp2
        let urlParameters: Parameters = [
            "otp": "\(finalOTP)"
        ]
        print(finalOTP)
        showLoading()
        APIHelper.verifyOTPAPI(urlParameters: urlParameters) { (success,response)  in
            if !success {
                dissmissLoader()
                let message = response.message
                print(message)
                self.view.makeToast(message)
            }else {
                dissmissLoader()
                let message = response.message
                print(message)
                if let codeCompletion = self.onCompletion {
                    codeCompletion(true)
                    self.dismiss(animated: true, completion: nil)
                }
                myApp.window?.rootViewController?.view.makeToast(message)
            }
        }
    }
    
    // Cancel Button Action
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if let codeCompletion = onCompletion {
            codeCompletion(false)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}

//MARK: - Extensions -

//MARK: UITextField Delegate Methods
extension VerifyOTPViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        switch textField {
        case firstCodeTxtField:
            secondCodeTxtField.becomeFirstResponder()
            return true
        case secondCodeTxtField:
            thirdCodeTxtField.becomeFirstResponder()
            return true
        case thirdCodeTxtField:
            fourthCodeTxtField.becomeFirstResponder()
            return true
        case fourthCodeTxtField:
            fifthCodeTxtField.resignFirstResponder()
            return true
        case fifthCodeTxtField:
            sixthCodeTxtField.resignFirstResponder()
            return true
        case sixthCodeTxtField:
            sixthCodeTxtField.resignFirstResponder()
            return true
        default:
            return true
        }
    }


    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        let string = textField.text ?? ""

        if textField.text?.count == 0 && string.count == 0{
            switch textField{
            case firstCodeTxtField:
                firstCodeTxtField.text = string
                firstCodeTxtField.becomeFirstResponder()
            case secondCodeTxtField:
                secondCodeTxtField.text = string
                firstCodeTxtField.becomeFirstResponder()
            case thirdCodeTxtField:
                thirdCodeTxtField.text = string
                secondCodeTxtField.becomeFirstResponder()
            case fourthCodeTxtField:
                fourthCodeTxtField.text = string
                thirdCodeTxtField.becomeFirstResponder()
            case fifthCodeTxtField:
                fifthCodeTxtField.text = string
                fourthCodeTxtField.becomeFirstResponder()
            case sixthCodeTxtField:
                sixthCodeTxtField.text = string
                fifthCodeTxtField.becomeFirstResponder()
            default:
                break
            }
            //return false
        }
        return
//        guard let _  = Range(range, in: currentText!) else{
//            return false
//        }
        //let updatedString = currentText!.replacingCharacters(in: stringRange, with: string)
        //print(updatedString)
//
        /*if string.count > 0{
            switch textField{
            case firstCodeTxtField:
                firstCodeTxtField.text = string
                secondCodeTxtField.becomeFirstResponder()
            case secondCodeTxtField:
                secondCodeTxtField.text = string
                thirdCodeTxtField.becomeFirstResponder()
            case thirdCodeTxtField:
                thirdCodeTxtField.text = string
                fourthCodeTxtField.becomeFirstResponder()
            case fourthCodeTxtField:
                fourthCodeTxtField.text = string
                fourthCodeTxtField.resignFirstResponder()
            default:
                break
            }
            //return false
        }

        if textField.text?.count == 0 && string.count == 0{
            switch textField{
            case firstCodeTxtField:
                firstCodeTxtField.text = string
                firstCodeTxtField.becomeFirstResponder()
            case secondCodeTxtField:
                secondCodeTxtField.text = string
                firstCodeTxtField.becomeFirstResponder()
            case thirdCodeTxtField:
                thirdCodeTxtField.text = string
                secondCodeTxtField.becomeFirstResponder()
            case fourthCodeTxtField:
                fourthCodeTxtField.text = string
                thirdCodeTxtField.becomeFirstResponder()
            default:
                break
            }
            //return false
        }
        else if textField.text!.count >= 1 && string.count == 0{
            textField.text = string
            //return false
        }

        else{
           // return false
        }*/
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let currentText = textField.text
        guard let stringRange = Range(range, in: currentText!) else{
            return false
        }
        let updatedString = currentText?.replacingCharacters(in: stringRange, with: string)
        print(updatedString ?? "")
        if (updatedString != "") {
            if !(updatedString?.isNumeric ?? false) {
                return false
            }
        }

        if (updatedString?.count ?? 0) > 1{
            switch textField{
            case firstCodeTxtField:
                secondCodeTxtField.text = string
                secondCodeTxtField.becomeFirstResponder()
            case secondCodeTxtField:
                thirdCodeTxtField.text = string
                thirdCodeTxtField.becomeFirstResponder()
            case thirdCodeTxtField:
                fourthCodeTxtField.text = string
                fourthCodeTxtField.becomeFirstResponder()
            case fourthCodeTxtField:
                fifthCodeTxtField.text = string
                fifthCodeTxtField.becomeFirstResponder()
            case fifthCodeTxtField:
                sixthCodeTxtField.text = string
                sixthCodeTxtField.becomeFirstResponder()
            case sixthCodeTxtField:
                sixthCodeTxtField.text = string
                sixthCodeTxtField.becomeFirstResponder()
            default:
                break
            }
            return false
        }

        if string.count > 0{
            switch textField{
            case firstCodeTxtField:
                firstCodeTxtField.text = string
                secondCodeTxtField.becomeFirstResponder()
            case secondCodeTxtField:
                secondCodeTxtField.text = string
                thirdCodeTxtField.becomeFirstResponder()
            case thirdCodeTxtField:
                thirdCodeTxtField.text = string
                fourthCodeTxtField.becomeFirstResponder()
            case fourthCodeTxtField:
                fourthCodeTxtField.text = string
                fifthCodeTxtField.becomeFirstResponder()
            case fifthCodeTxtField:
                fifthCodeTxtField.text = string
                sixthCodeTxtField.becomeFirstResponder()
            case sixthCodeTxtField:
                sixthCodeTxtField.text = string
                sixthCodeTxtField.becomeFirstResponder()
            default:
                break
            }
            return false
        }

        if textField.text?.count == 0 && string.count  == 0{
            switch textField{
            case firstCodeTxtField:
                firstCodeTxtField.text = string
                firstCodeTxtField.becomeFirstResponder()
            case secondCodeTxtField:
                secondCodeTxtField.text = string
                firstCodeTxtField.becomeFirstResponder()
            case thirdCodeTxtField:
                thirdCodeTxtField.text = string
                secondCodeTxtField.becomeFirstResponder()
            case fourthCodeTxtField:
                fourthCodeTxtField.text = string
                thirdCodeTxtField.becomeFirstResponder()
            case fifthCodeTxtField:
                fifthCodeTxtField.text = string
                fourthCodeTxtField.becomeFirstResponder()
            case sixthCodeTxtField:
                sixthCodeTxtField.text = string
                fifthCodeTxtField.becomeFirstResponder()
            default:
                break
            }
            return false
        }
        else if textField.text!.count >= 1 && string.count == 0{
            textField.text = string
            return false
        }else {
            return false
        }
    }
}
