//
//  VerifyOTPViewController.swift
//  Actorpay
//
//  Created by iMac on 07/01/22.
//

import UIKit

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
    
    @IBOutlet weak var verifyOtpAlertView: UIView!
    @IBOutlet weak var verifyOtpView: UIView!
    @IBOutlet weak var verifyOTPButtonView: UIView!
 
    var isEmail = false
    
    //MARK: - Life Cycles -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(isEmail)
        // Do any additional setup after loading the view.
        topCorners(bgView: verifyOtpView, cornerRadius: 10, maskToBounds: true)
        bottomCorner(bgView: verifyOTPButtonView, cornerRadius: 10, maskToBounds: true)
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        self.showAnimate()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: - Selectors -
    
    // OK Button Action
    @IBAction func okButtonAction(_ sender: UIButton) {
        removeAnimate()
        self.dismiss(animated: true, completion: nil)
    }
    
    // Cancel Button Action
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        removeAnimate()
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Helper Functions -
    
    // Present View With Animation
    func showAnimate(){
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    // Remove View With Animation
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
    
    // View End Editing
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(touches.first?.view != verifyOtpAlertView) {
            removeAnimate()
        }
    }

}


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
