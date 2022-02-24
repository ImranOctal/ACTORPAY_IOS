//
//  FilterOrderViewController.swift
//  Actorpay Merchant
//
//  Created by iMac on 12/01/22.
//

import UIKit
import Alamofire
import DropDown

class FilterOrderViewController: UIViewController {
    
    //MARK: - Properties -
    
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var orderNoTextField: UITextField!
    @IBOutlet weak var merchantNameTextField: UITextField!
    @IBOutlet weak var totalAmountTextField: UITextField!
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!
    @IBOutlet weak var statusTextField: UITextField!
    
    var startDatePicker = UIDatePicker()
    var endDatePicker = UIDatePicker()
    typealias comp = (_ params: Parameters?) -> Void
    var completion:comp?
    var orderStatusDropDown =  DropDown()
    var orderStatus: String = ""
    var statusData: [String] = []
    var filterOrderParm: Parameters?

    //MARK: - Life Cycles -

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        statusData = ["Select Status","SUCCESS","READY","CANCELLED","PARTIALLY_CANCELLED","DISPATCHED","RETURNING","PARTIALLY_RETURNING","RETURNED","PARTIALLY_RETURNED","DELIVERED","PENDING","FAILURE"]
        topCorner(bgView: filterView, maskToBounds: true)
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.showAnimate()
        setStartDatePicker()
        setEndDatePicker()
        setupOrderStatusDropDown()
        self.setFilterData()
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
        orderNoTextField.text = ""
        merchantNameTextField.text = ""
        totalAmountTextField.text = ""
        startDateTextField.text = ""
        endDateTextField.text = ""
        statusTextField.text = ""
        orderStatus = ""
        filterOrderParm = nil
    }
    
    // Apply Button Action
    @IBAction func applyButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let param : Parameters = [
            "totalPrice":totalAmountTextField.text ?? "",
            "merchantName": merchantNameTextField.text ?? "",
            "merchantId":"",
            "customerEmail":"",
            "status":"true",
            "startDate":startDateTextField.text ?? "",
            "endData":endDateTextField.text ?? "",
            "priceRangeFrom": "",
            "priceRangeTo": "",
            "orderNo":orderNoTextField.text ?? "",
            "orderId":"",
            "orderStatus":orderStatus
//            "orderStatus":statusTextField.text ?? ""
        ]
        if let codeCompletion = completion {
            codeCompletion(param)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // Status Button Acction
    @IBAction func statusButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        orderStatusDropDown.show()
    }
    
    //MARK: - Helper Functions -
    
    // Set Filter Data
    func setFilterData() {
        orderNoTextField.text = filterOrderParm?["orderNo"] as? String
        startDateTextField.text = filterOrderParm?["startDate"] as? String
        endDateTextField.text = filterOrderParm?["endData"] as? String
        orderStatus = (filterOrderParm?["orderStatus"] as? String) ?? ""
        statusTextField.text = orderStatus.replacingOccurrences(of: "_", with: " ", options: .literal, range: nil)
        merchantNameTextField.text = filterOrderParm?["merchantName"] as? String
        totalAmountTextField.text = filterOrderParm?["totalPrice"] as? String
    }
    
    // SetUp Order Status Drop Down
    func setupOrderStatusDropDown() {
        orderStatusDropDown.anchorView = statusTextField
        orderStatusDropDown.dataSource = statusData.map({$0.replacingOccurrences(of: "_", with: " ", options: .literal, range: nil)})
        orderStatusDropDown.backgroundColor = .white
        orderStatusDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            if item == "Select Status" {
                self.statusTextField.text = ""
                return
            }
            self.statusTextField.text = item
            self.orderStatus = statusData[index]
            self.view.endEditing(true)
            self.orderStatusDropDown.hide()
        }
        orderStatusDropDown.topOffset = CGPoint(x: -10, y: -50)
        orderStatusDropDown.width = statusTextField.frame.width + 60
        orderStatusDropDown.direction = .top
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

}
