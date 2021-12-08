//
//  RemittanceViewController.swift
//  Actorpay
//
//  Created by iMac on 07/12/21.
//

import UIKit
import DropDown

class RemittanceViewController: UIViewController {
    //MARK:- Properties -
    
    // main View
    @IBOutlet weak var mainView: UIView!
    
    // segment View
    @IBOutlet weak var firstCircleView: UIView!
    @IBOutlet weak var secondCircleView: UIView!
    @IBOutlet weak var thirdCircleView: UIView!
    
    // Country View
    @IBOutlet weak var chooseCountryView: UIView!
    @IBOutlet weak var chooseCountryTextField: UITextField!
    @IBOutlet weak var currencyTypeTextField: UITextField!
    
    // Amount View
    @IBOutlet weak var amountView: UIView!
    @IBOutlet weak var amountTextField: UITextField!
    
    // baneficiary Details
    @IBOutlet weak var baneficiaryDetailView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var accountNumberTextField: UITextField!
    @IBOutlet weak var uniqueCodeTextField: UITextField!
    @IBOutlet weak var selectBranchTextField: UITextField!
    
    
    var isFirst = true
    var isSecond = false
    var isThird = false
    
    let countryDropDown = DropDown()
    let nameDropDown = DropDown()
    let branchDropDown = DropDown()
    
    //MARK:- Life Cycle Function -
    override func viewDidLoad() {
        super.viewDidLoad()
        topCorner(bgView: mainView, maskToBounds: true)
        setupPageControlview()
        // Do any additional setup after loading the view.
    }
    //MARK:- Selectors -
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        //Back Button Action
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextButtonAction(_ sender: UIButton) {
        //Next Button Action
        self.view.endEditing(true)
        if sender.tag == 1001 {
            if !chooseCountryValidationView() {
                return
            }
            isFirst = false
            isSecond = true
            isThird = false
            setupPageControlview()
        }else {
            if !amountValidationView() {
                return
            }
            isFirst = false
            isSecond = false
            isThird = true
            setupPageControlview()
        }
    }
    
    @IBAction func payNowButtonAction(_ sender: UIButton) {
        //Pay Now Button Action
        self.view.endEditing(true)
        if !baneficiaryValidationView() {
            return
        }
    }
    
    @IBAction func chooseCountryDropDown(_ sender: UIButton) {
        self.view.endEditing(true)
        countryDropDown.show()
    }
    
    @IBAction func nameDropDown(_ sender: UIButton) {
        self.view.endEditing(true)
        nameDropDown.show()
    }
    
    @IBAction func selectBranchDropDown(_ sender: UIButton) {
        self.view.endEditing(true)
        branchDropDown.show()
    }
    //MARK:- Helper Functions -
    
    func setupPageControlview(){
        firstCircleView.layer.borderWidth = isFirst ? 5 : 0
        firstCircleView.layer.borderColor = isFirst ? UIColor(named: "BlueColor")?.cgColor : UIColor.white.cgColor
        firstCircleView.backgroundColor = isFirst ? .white : UIColor(hexFromString: "#E6E7E8")
        secondCircleView.layer.borderWidth = isSecond ? 5 : 0
        secondCircleView.layer.borderColor = isSecond ? UIColor(named: "BlueColor")?.cgColor : UIColor.white.cgColor
        secondCircleView.backgroundColor = isSecond ? .white : UIColor(hexFromString: "#E6E7E8")
        thirdCircleView.layer.borderWidth = isThird ? 5 : 0
        thirdCircleView.layer.borderColor = isThird ? UIColor(named: "BlueColor")?.cgColor : UIColor.white.cgColor
        thirdCircleView.backgroundColor = isThird ? .white : UIColor(hexFromString: "#E6E7E8")
        chooseCountryView.isHidden = !isFirst
        amountView.isHidden = !isSecond
        baneficiaryDetailView.isHidden = !isThird
        chooseCountryDropDown()
        baneficiaryNameDropDown()
        selectBranchDropDown()
    }
    
    func chooseCountryDropDown()  {
        countryDropDown.anchorView = chooseCountryTextField
        countryDropDown.dataSource = ["Africa","America","Canada","Germany","India"]
        countryDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.chooseCountryTextField.text = item
            self.view.endEditing(true)
            self.countryDropDown.hide()
        }
        
        countryDropDown.bottomOffset = CGPoint(x: 0, y: 50)
        countryDropDown.direction = .bottom
    }
    
    func baneficiaryNameDropDown()  {
        nameDropDown.anchorView = nameTextField
        nameDropDown.dataSource = ["Jonh","Smith"]
        nameDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.nameTextField.text = item
            self.view.endEditing(true)
            self.nameDropDown.hide()
        }
        
        nameDropDown.bottomOffset = CGPoint(x: 0, y: 50)
        nameDropDown.direction = .bottom
    }
    
    func selectBranchDropDown()  {
        branchDropDown.anchorView = selectBranchTextField
        branchDropDown.dataSource = ["Sarathana","Hirabag","Vesu","Kamrej"]
        branchDropDown.selectionAction = { [unowned self] (intabbdex: Int, item: String) in
            self.selectBranchTextField.text = item
            self.view.endEditing(true)
            self.branchDropDown.hide()
        }
        branchDropDown.bottomOffset = CGPoint(x: 0, y: 50)
        branchDropDown.direction = .bottom
    }
    
    func chooseCountryValidationView() -> Bool{
        // Choose Country Validation Fields
        if chooseCountryTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            self.alertViewController(message: "Please choose a country name.")
            return false
        }
        if currencyTypeTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            self.alertViewController(message: "Please enter currency type.")
            return false
        }
        return true
    }
    
    func amountValidationView() -> Bool{
        // Amount Validation Fields
        if amountTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            self.alertViewController(message: "Please enter an amount.")
            return false
        }
        return true
    }
    
    func baneficiaryValidationView() -> Bool{
        // Amount Validation Fields
        if nameTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            self.alertViewController(message: "Please enter a name.")
            return false
        }
        if emailTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            self.alertViewController(message: "Please enter an email.")
            return false
        }
        if accountNumberTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            self.alertViewController(message: "Please enter an account Number.")
            return false
        }
        if uniqueCodeTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            self.alertViewController(message: "Please enter an unique Code.")
            return false
        }
        if selectBranchTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            self.alertViewController(message: "Please select your branch.")
            return false
        }
        return true
    }
}
