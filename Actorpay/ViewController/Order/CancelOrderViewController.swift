//
//  CancelOrderViewController.swift
//  Actorpay
//
//  Created by iMac on 25/01/22.
//

import UIKit
import Alamofire

class CancelOrderViewController: UIViewController {
    
    //MARK: - Properties -

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var orderNoLbl: UILabel!
    @IBOutlet weak var orderDateLbl: UILabel!
    @IBOutlet weak var orderPriceLbl: UILabel!
    @IBOutlet weak var orderTextView: UITextView!
    @IBOutlet weak var cancelOrderTextViewValidationLbl: UILabel!
    @IBOutlet weak var orderTblView: UITableView! {
        didSet {
            orderTblView.delegate = self
            orderTblView.dataSource = self
        }
    }
    
    var orderItems: OrderItems?
    var orderItemDtos: OrderItemDtos?
    var placeHolder = ""
    var productImage = UIImage(named:"NewLogo")
    
    //MARK: - Life Cycles -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.setUpTextView()
        topCorner(bgView: bgView, maskToBounds: true)
        self.setOrderData()
    }
    
    //MARK: - Selectors -
    
    // Back Button Action
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // Cancel Order Button Action
    @IBAction func cancelOrderBtnAction(_ sender: UIButton) {
        cancelOrReturnOrderApi(orderNo: orderItems?.orderNo ?? "")
    }
    
    //MARK: - Helper Functions -
    
    // SetUp Text View
    func setUpTextView() {
        cancelOrderTextViewValidationLbl.isHidden = true
        placeHolder = "Enter Cancel Reason"
        orderTextView.delegate = self
        orderTextView.text = placeHolder
        if orderTextView.text == placeHolder {
            orderTextView.textColor = .lightGray
        } else {
            orderTextView.textColor = .black
        }
    }
    
    // Set Order Data
    func setOrderData() {
        orderNoLbl.text = orderItems?.orderNo
        orderDateLbl.text = "Order Date: \(orderItems?.createdAt?.toFormatedDate(from: "yyyy-MM-dd hh:mm", to: "dd MMM yyyy HH:MM") ?? "")"
        orderPriceLbl.text = "₹\((orderItems?.totalPrice ?? 0.0).doubleToStringWithComma())"
    }
        
}

//MARK: - Extensions -

//MARK: Api Call
extension CancelOrderViewController {
    
    // Cancel Or Return Order Api
    func cancelOrReturnOrderApi(orderNo: String) {
        var imgData: Data?
        
        let params: Parameters = [
            "cancelOrder": [
                "cancellationRequest":"CANCELLED",
                "cancelReason": orderTextView.text ?? "",
                "orderItemIds":[orderItemDtos?.orderItemId ?? ""]
            ]
        ]
        if productImage != nil {
            imgData = self.productImage?.jpegData(compressionQuality: 0.1)
        }
        showLoading()
        APIHelper.cancelOrReturnOrderApi(params:params, imgData: imgData, imageKey: "file", orderNo: orderNo) { (success, response) in
            if !success {
                dissmissLoader()
                let message = response.message
                myApp.window?.rootViewController?.view.makeToast(message)
            }else {
                dissmissLoader()
                let message = response.message
                myApp.window?.rootViewController?.view.makeToast(message)
                self.navigationController?.popViewController(animated: true)
                NotificationCenter.default.post(name:  Notification.Name("getOrderDetailsApi"), object: self)
                NotificationCenter.default.post(name:  Notification.Name("reloadOrderListApi"), object: self)
            }
        }
    }
    
}

//MARK: TableView Setup
extension CancelOrderViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderItemTableViewCell", for: indexPath) as! OrderItemTableViewCell
        cell.cancelOrderItemDtos = orderItemDtos
        return cell
    }
    
}

// MARK: Text View Delegate Methods
extension CancelOrderViewController : UITextViewDelegate{
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.text == placeHolder {
            textView.text = ""
        }
        
        if textView.text == placeHolder {
            textView.isSelectable = false
        } else {
            textView.isSelectable = true
        }
        
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars <= 500
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.text == placeHolder {
            textView.text = nil
            
            textView.textColor = UIColor.black
        }
        
        if textView.text == placeHolder {
            textView.isSelectable = false
        } else {
            textView.isSelectable = true
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text == placeHolder {
            textView.isSelectable = true
        } else {
            textView.isSelectable = true
        }
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        if textView.text.count == 0 {
            textView.text = placeHolder
            textView.textColor = UIColor.lightGray
        } else {
            textView.textColor = UIColor.black
        }
        
        if textView.text == placeHolder {
            textView.isSelectable = false
            cancelOrderTextViewValidationLbl.isHidden = false
            cancelOrderTextViewValidationLbl.text = ValidationManager.shared.emptyCancelOrderDescription
        } else {
            textView.isSelectable = true
            cancelOrderTextViewValidationLbl.isHidden = true
        }
    }
    
}
