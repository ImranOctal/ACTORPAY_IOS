//
//  DTHRechageViewController.swift
//  Actorpay
//
//  Created by iMac on 08/12/21.
//

import UIKit

class DTHRechageViewController: UIViewController {

    //MARK: - Properties -
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
        }
    }
    @IBOutlet weak var mobileNumberTextField: UITextField! {
        didSet {
            self.mobileNumberTextField.delegate = self
        }
    }
    @IBOutlet weak var amountTextField: UITextField! {
        didSet {
            self.amountTextField.delegate = self
        }
    }
    @IBOutlet weak var mobileRechargeRadioBtn: UIButton!
    @IBOutlet weak var dthRechargeRadioBtn: UIButton!
    @IBOutlet weak var prepaidRadioBtn: UIButton!
    @IBOutlet weak var postpaidRadioBtn: UIButton!
    @IBOutlet weak var mobileRechargeTypeView: UIView!
    @IBOutlet weak var mobileNumberValidationLbl: UILabel!
    @IBOutlet weak var amountValidationLbl: UILabel!
    
    var mobileOperatorArr: [String] = ["Airtel","JIO","VI","BSNL","MTNL"]
    var dthOperatorArr: [String] = ["Airtel","JIO","Vodaphone","D2H","MTNL"]
    var isMobileAndDTH = true
    var isPrepaidAndPostpaid = true
    
    //MARK: - Life Cycles -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        topCorner(bgView: mainView, maskToBounds: true)
        self.setMobileRechargeAndDTHRechargeRadioBtnUI()
        self.setPrepaidAndPostpaidBtnUI()
        self.manageValidationLabel()
    }
    
    //MARK: - Selectors -

    // Special Plan Button Action
    @IBAction func specialPlanBUttonAction(_ sender: UIButton) {
        self.view.endEditing(true)
    }
    
    // Back Button Action
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    // Recharge Now Button Action
    @IBAction func rechageNowButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if mobileAndDTHValidation() {
            self.manageValidationLabel()
            let newVC = self.storyboard?.instantiateViewController(withIdentifier: "DummyTransactionViewController") as! DummyTransactionViewController
            self.navigationController?.pushViewController(newVC, animated: true)
        }
    }
    
    // Mobile And DTH Recharge Radio Button Action
    @IBAction func mobileAndDTHRechargeRadioBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if sender.tag == 1001 {
            isMobileAndDTH = true
        } else {
            isMobileAndDTH = false
        }
        self.setMobileRechargeAndDTHRechargeRadioBtnUI()
    }
    
    // Prepaid And Postpaid Radio Button Action
    @IBAction func prepaidAndPostpaidRadioBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if sender.tag == 1003 {
            isPrepaidAndPostpaid = true
        } else {
            isPrepaidAndPostpaid = false
        }
        self.setPrepaidAndPostpaidBtnUI()
    }
    
    //MARK: - Helper Functions -
    
    // Set Mobile Recharge And DTH Recharge Button UI And Action
    func setMobileRechargeAndDTHRechargeRadioBtnUI() {
        mobileRechargeRadioBtn.setImage(UIImage(named: isMobileAndDTH ? "fillRadioBtn.png" : "blankRadioBtn.png"), for: .normal)
        dthRechargeRadioBtn.setImage(UIImage(named: !isMobileAndDTH ? "fillRadioBtn.png" : "blankRadioBtn.png"), for: .normal)
        mobileRechargeRadioBtn.tintColor = isMobileAndDTH ? UIColor(hexFromString: "40D9C8") : UIColor.darkGray
        dthRechargeRadioBtn.tintColor =  !isMobileAndDTH ? UIColor(hexFromString: "40D9C8") : UIColor.darkGray
        mobileNumberTextField.placeholder = isMobileAndDTH ? "Enter Mobile Number" : "Enter DTH Number"
        mobileRechargeTypeView.isHidden = !isMobileAndDTH
        mobileNumberTextField.text = ""
        amountTextField.text = ""
        collectionView.reloadData()
    }
    
    // Set Prepaid And Postpaid Radio Button UI And Action
    func setPrepaidAndPostpaidBtnUI() {
        prepaidRadioBtn.setImage(UIImage(named: isPrepaidAndPostpaid ? "fillRadioBtn.png" : "blankRadioBtn.png"), for: .normal)
        postpaidRadioBtn.setImage(UIImage(named: !isPrepaidAndPostpaid ? "fillRadioBtn.png" : "blankRadioBtn.png"), for: .normal)
        prepaidRadioBtn.tintColor = isPrepaidAndPostpaid ? UIColor(hexFromString: "40D9C8") : UIColor.darkGray
        postpaidRadioBtn.tintColor =  !isPrepaidAndPostpaid ? UIColor(hexFromString: "40D9C8") : UIColor.darkGray
    }
    
    // Mobile And DTH Recharge Validation
    func mobileAndDTHValidation() -> Bool {
        var isValidate = true
        
        if mobileNumberTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            mobileNumberValidationLbl.isHidden = false
            mobileNumberValidationLbl.text = isMobileAndDTH ? ValidationManager.shared.emptyMobileNumber : ValidationManager.shared.emptyDTHNumber
            isValidate = false
        } else {
            mobileNumberValidationLbl.isHidden = true
        }
        
        if amountTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            amountValidationLbl.isHidden = false
            amountValidationLbl.text = ValidationManager.shared.emptyAmount
            isValidate = false
        } else {
            amountValidationLbl.isHidden = true
        }
        
        return isValidate
    }
    
    // Manage Validation Label
    func manageValidationLabel() {
        mobileNumberValidationLbl.isHidden = true
        amountValidationLbl.isHidden = true
    }
    
}

//MARK: - Extensions -

//MARK: Collection View SetUp
extension DTHRechageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isMobileAndDTH {
            return mobileOperatorArr.count
        } else {
            return dthOperatorArr.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RechargeOperatorCollectionViewCell", for: indexPath) as! RechargeOperatorCollectionViewCell
        cell.titleLabel.text = isMobileAndDTH ? mobileOperatorArr[indexPath.row] : dthOperatorArr[indexPath.row]
        return cell
    }
    
}

//MARK: TextField Delegate Methods
extension DTHRechageViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        switch textField {
        case mobileNumberTextField:
            if mobileNumberTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
                mobileNumberValidationLbl.isHidden = false
                mobileNumberValidationLbl.text = isMobileAndDTH ? ValidationManager.shared.emptyMobileNumber : ValidationManager.shared.emptyDTHNumber
            } else {
                mobileNumberValidationLbl.isHidden = true
            }
        case amountTextField:
            if amountTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
                amountValidationLbl.isHidden = false
                amountValidationLbl.text = ValidationManager.shared.emptyAmount
            } else {
                amountValidationLbl.isHidden = true
            }
        default:
            break
        }
    }
    
}
