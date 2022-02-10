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
    var selectedIndex = 0
    
    //MARK:- Life Cycle Function -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        topCorner(bgView: mainView, maskToBounds: true)
        setupPageControlview()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    //MARK:- Selectors -
    
    // Back Button Action
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if selectedIndex == 1 {
            print("Last")
            selectedIndex = 0
            isFirst = true
            isSecond = false
            isThird = false
            setupPageControlview()
        }else if selectedIndex == 2 {
            print("Middle")
            selectedIndex = 1
            isFirst = false
            isSecond = true
            isThird = false
            setupPageControlview()
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    // Cart Button Action
    @IBAction func cartButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let newVC = self.storyboard?.instantiateViewController(withIdentifier: "MyCartViewController") as! MyCartViewController
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    
    //Next Button Action
    @IBAction func nextButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if sender.tag == 1001 {
//            if !chooseCountryValidationView() {
//                return
//            }
            selectedIndex = 1
            isFirst = false
            isSecond = true
            isThird = false
            setupPageControlview()
            
        }else {
//            if !amountValidationView() {
//                return
//            }
            selectedIndex = 2
            isFirst = false
            isSecond = false
            isThird = true
            setupPageControlview()
        }
    }
    
    // Pay Now Button Action
    @IBAction func payNowButtonAction(_ sender: UIButton) {
        //Pay Now Button Action
        self.view.endEditing(true)
//        if !baneficiaryValidationView() {
//            return
//        }
    }
    
    // Choose Country Drop Down Button Action
    @IBAction func chooseCountryDropDown(_ sender: UIButton) {
        self.view.endEditing(true)
        countryDropDown.show()
    }
    
    // Name Drop Down Button Action
    @IBAction func nameDropDown(_ sender: UIButton) {
        self.view.endEditing(true)
        nameDropDown.show()
    }
    
    // Select Branch Drop Down Button Action
    @IBAction func selectBranchDropDown(_ sender: UIButton) {
        self.view.endEditing(true)
        branchDropDown.show()
    }
    
    //MARK:- Helper Functions -
    
    // SetUp Page Control View
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
    
    // SetUp Country Drop Down
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
    
    // SetUp Baneficiary Name Drop Down
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

    // Select Branch Drop Down
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
    
    // Choose Country Validation Fields
    func chooseCountryValidationView() -> Bool{
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
    
    // Amount Validation Fields
    func amountValidationView() -> Bool {
        if amountTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            self.alertViewController(message: "Please enter an amount.")
            return false
        }
        return true
    }
    
    // Baneficiary Validation
    func baneficiaryValidationView() -> Bool {
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
