//
//  OrderSummaryViewController.swift
//  Actorpay
//
//  Created by iMac on 29/12/21.
//

import UIKit
import SDWebImage
import Alamofire
import PopupDialog

class OrderSummaryViewController: UIViewController {
    
    //MARK: - Properties -
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var tblViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var orderDateAndTimeLbl: UILabel!
    @IBOutlet weak var orderAmountLbl: UILabel!
    @IBOutlet weak var orderNumberLbl: UILabel!
    @IBOutlet weak var deliveryAddressLbl: UILabel!
    @IBOutlet weak var shopNameLbl: UILabel!
    @IBOutlet weak var buttonAction: UIButton!
    
    
    var orderNo = ""
    var orderItems: OrderItems?
    var productImage = UIImage(named:"")
    var isPlaceOrder = false
    //MARK: - Life Cycles -

    override func viewDidLoad() {
        super.viewDidLoad()
        statusView.isHidden = !isPlaceOrder
        let name = isPlaceOrder ? "EXPLORE MORE" : "CANCEL ORDER"
        buttonAction.setTitle(name, for: .normal)
        topCorner(bgView: bgView, maskToBounds: true)
        self.setUpTableView()
        self.getOrderDetailsApi()
    }
    
    //MARK: - Selectors -
    
    //Back Button Action
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // Cancel Order Button Action
    @IBAction func cancelOrderBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if sender.currentTitle == "CANCEL ORDER" {
            let newVC = (self.storyboard?.instantiateViewController(withIdentifier: "CustomAlertViewController") as? CustomAlertViewController)!
            newVC.view.backgroundColor = UIColor(white: 0, alpha: 0.5)
            newVC.setUpCustomAlert(titleStr: "Cancel Order", descriptionStr: "Are you sure you want to Cancel This Order?", isShowCancelBtn: false)
            newVC.customAlertDelegate = self
            self.definesPresentationContext = true
            self.providesPresentationContextTransitionStyle = true
            newVC.modalPresentationStyle = .overCurrentContext
            self.navigationController?.present(newVC, animated: true, completion: nil)
        }else{
            self.navigationController?.popToRootViewController(animated: true)
        }        
    }
    
    //MARK: - Helper Functions -
    
    //Table View SetUp
    func setUpTableView() {
        self.tblView.delegate = self
        self.tblView.dataSource = self
    }
    
    // Set Order Details Data
    func setUpOrderDetailsData() {
        orderAmountLbl.text = "₹\(orderItems?.totalPrice ?? 0.0)"
        orderNumberLbl.text = "Order Number: \(orderItems?.orderNo ?? "")"
        orderDateAndTimeLbl.text = "Order Date & Time: \(orderItems?.createdAt ?? "")"
        shopNameLbl.text = "\(orderItems?.customer?.firstName ?? "") \(orderItems?.customer?.lastName ?? "")"
        deliveryAddressLbl.text = "\(orderItems?.shippingAddressDTO?.addressLine1 ?? "")\n\(orderItems?.shippingAddressDTO?.addressLine2 ?? "")\n\(orderItems?.shippingAddressDTO?.city ?? "")\n\(orderItems?.shippingAddressDTO?.country ?? "")"
    }
    
}

//MARK:- Extensions -

//MARK: Api Call
extension OrderSummaryViewController {
    
    // get Order Details Api
    func getOrderDetailsApi() {
        showLoading()
        APIHelper.getOrderDetailsApi(orderNo: orderNo) { (success, response) in
            if !success {
                dissmissLoader()
                let message = response.message
                myApp.window?.rootViewController?.view.makeToast(message)
            }else {
                dissmissLoader()
                let data = response.response["data"]
                self.orderItems = OrderItems.init(json: data)
                let message = response.message
//                myApp.window?.rootViewController?.view.makeToast(message)
                print(message)
                self.tblViewHeightConst.constant = CGFloat(103 * (self.orderItems?.orderItemDtos?.count ?? 0))
                self.setUpOrderDetailsData()
                self.tblView.reloadData()
            }
        }
    }
    
    // Cancel Or Return Order Api
    func cancelOrReturnOrderApi(orderNo: String) {
        var imgData: Data?
        let params: Parameters = [
                "cancellationType":"RETURNING",
                "cancelReason":"Damaged Product"
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
            }
        }
    }
}

//MARK: Table View SetUp
extension OrderSummaryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderItems?.orderItemDtos?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderItemTableViewCell", for: indexPath) as! OrderItemTableViewCell
        let item = orderItems?.orderItemDtos?[indexPath.row]
        cell.titleLbl.text = item?.productName
        cell.qtyLbl.text = "Quantity: \(item?.productQty ?? 0)"
        cell.priceLbl.text = "Price: ₹\(item?.totalPrice ?? 0.0)"
        cell.imgView.sd_setImage(with: URL(string: item?.image ?? ""), placeholderImage: UIImage(named: "logo"), options: SDWebImageOptions.allowInvalidSSLCertificates, completed: nil)
        return cell
    }
    
    
}

//MARK: CustomAlert Delegate Methods
extension OrderSummaryViewController: CustomAlertDelegate {
    
    func okButtonclick() {
        cancelOrReturnOrderApi(orderNo: orderItems?.orderNo ?? "")
    }
    
    func cancelButtonClick() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
