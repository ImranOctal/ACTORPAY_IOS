//
//  WalletFilterViewController.swift
//  Actorpay
//
//  Created by iMac on 24/02/22.
//

import UIKit
import Alamofire
import DropDown

class WalletFilterViewController: UIViewController {

    //MARK: - Properties -
    
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var transactionAmountFromTxtField: UITextField!
    @IBOutlet weak var transactionAmountToTxtField: UITextField!
    @IBOutlet weak var transactionRemarkTxtField: UITextField!
    @IBOutlet weak var transactionTypeTxtField: UITextField!
    @IBOutlet weak var walletTransactionIdTxtField: UITextField!
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!
    
    var startDatePicker = UIDatePicker()
    var endDatePicker = UIDatePicker()
    typealias comp = (_ params: Parameters?) -> Void
    var completion:comp?
    var transactionTypeDropDown =  DropDown()
    var transactionTypeData: [String] = []
    var filterOrderParm: Parameters?
    
    //MARK: - Life Cycles -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        transactionTypeData = ["Select Status","CREDIT","DEBIT"]
        topCorner(bgView: filterView, maskToBounds: true)
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.showAnimate()
        setupOrderStatusDropDown()
        self.setFilterData()
        self.setStartDatePicker()
        self.setEndDatePicker()
    }
    
    //MARK: - Selectors -
    
    // Close Button Action
    @IBAction func closeButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        removeAnimate()
        if let codeCompletion = completion {
            codeCompletion(filterOrderParm)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // Reset Button Action
    @IBAction func resetButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        transactionAmountFromTxtField.text = ""
        transactionAmountToTxtField.text = ""
        transactionRemarkTxtField.text = ""
        transactionTypeTxtField.text = ""
        walletTransactionIdTxtField.text = ""
        startDateTextField.text = ""
        endDateTextField.text = ""
        filterOrderParm = nil
    }
    
    // Apply Button Action
    @IBAction func applyButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let param : Parameters = [
            "transactionAmountFrom":transactionAmountFromTxtField.text ?? "",
            "transactionAmountTo":transactionAmountToTxtField.text ?? "",
            "transactionRemark":transactionRemarkTxtField.text ?? "",
            "transactionTypes":transactionTypeTxtField.text ?? "",
            "walletTransactionId":walletTransactionIdTxtField.text ?? "",
            "startDate":startDateTextField.text ?? "",
            "endDate":endDateTextField.text ?? ""
        ]
        if let codeCompletion = completion {
            codeCompletion(param)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // Transaction Type Button Acction
    @IBAction func transactionTypeButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        transactionTypeDropDown.show()
    }
    
    //MARK: - Helper Functions -
    
    // Set Filter Data
    func setFilterData() {
        startDateTextField.text = filterOrderParm?["startDate"] as? String
        endDateTextField.text = filterOrderParm?["endDate"] as? String
        transactionAmountFromTxtField.text = filterOrderParm?["transactionAmountFrom"] as? String
        transactionAmountToTxtField.text = filterOrderParm?["transactionAmountTo"] as? String
        transactionRemarkTxtField.text = filterOrderParm?["transactionRemark"] as? String
        transactionTypeTxtField.text = filterOrderParm?["transactionTypes"] as? String
        walletTransactionIdTxtField.text = filterOrderParm?["walletTransactionId"] as? String
    }
    
    // SetUp Order Status Drop Down
    func setupOrderStatusDropDown() {
        transactionTypeDropDown.anchorView = transactionTypeTxtField
        transactionTypeDropDown.dataSource = transactionTypeData
        transactionTypeDropDown.backgroundColor = .white
        transactionTypeDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            if item == "Select Status" {
                self.transactionTypeTxtField.text = ""
                return
            }
            self.transactionTypeTxtField.text = item
            self.view.endEditing(true)
            self.transactionTypeDropDown.hide()
        }
        transactionTypeDropDown.topOffset = CGPoint(x: -10, y: -50)
        transactionTypeDropDown.width = transactionTypeTxtField.frame.width + 60
        transactionTypeDropDown.direction = .top
    }
    
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
                self.view.endEditing(true)
                self.view.removeFromSuperview()
            }
        });
    }
    
    // View End Editing
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let currentPoint = touch.location(in: self.view)
            if !(filterView.frame.contains(currentPoint)) {
                removeAnimate()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    // Set Date Picker To FromTextField
    func setStartDatePicker() {
        startDatePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            startDatePicker.preferredDatePickerStyle = .wheels
        }
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Ok", style: .plain, target: self, action: #selector(fromTxtFieldDoneDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        startDateTextField.inputAccessoryView = toolbar
        startDateTextField.inputView = startDatePicker
    }
    
    // Set Date Picker To ToTextField
    func setEndDatePicker() {
        endDatePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            endDatePicker.preferredDatePickerStyle = .wheels
        }
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Ok", style: .plain, target: self, action: #selector(toTxtFieldDoneDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        endDateTextField.inputAccessoryView = toolbar
        endDateTextField.inputView = endDatePicker
    }
    
    // FromTextField DatePicker Done Button Action
    @objc func fromTxtFieldDoneDatePicker(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        startDateTextField.text = formatter.string(from: startDatePicker.date)
        self.view.endEditing(true)
    }
    
    // ToTextField DatePicker Done Button Action
    @objc func toTxtFieldDoneDatePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        endDateTextField.text = formatter.string(from: endDatePicker.date)
        self.view.endEditing(true)
    }
    
    // Date Picker Cancel Button Action
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
}
