//
//  CheckoutViewController.swift
//  Actorpay
//
//  Created by iMac on 21/12/21.
//

import UIKit
import Alamofire

class CheckoutViewController: UIViewController {
    
    //MARK: - Properties -
    
    @IBOutlet weak var mainView: UIView! {
        didSet{
            topCorner(bgView: mainView, maskToBounds: true)
        }
    }
    @IBOutlet weak var addressTableView: UITableView! {
        didSet{
            addressTableView.delegate = self
            addressTableView.dataSource = self
        }
    }
    @IBOutlet weak var addressTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var priceView: UIView! {
        didSet{
            topCornerWithShadow(bgView: priceView, maskToBounds: false)
        }
    }
    @IBOutlet weak var subTotalLbl: UILabel!
    @IBOutlet weak var gstLbl: UILabel!
    @IBOutlet weak var totalLbl: UILabel!
    @IBOutlet weak var shippingChargesLbl: UILabel!
    @IBOutlet weak var walletPaymentRadioButton: UIButton!
    @IBOutlet weak var codPaymentRadioButton: UIButton!
    @IBOutlet weak var walletBalanceLbl: UILabel!
    @IBOutlet weak var walletBalanceErrorView: UIView!
    
    var selectedAddressIndex: Int = 0
    var selectedCardIndex : IndexPath?
    var shippingAddressList: AddressList?
    var page = 0
    var totalCount = 10
    var addressListItems:[AddressItems] = []
    var selectedAddress:AddressItems?
    var cartList: CartList?
    var orderList: OrderItems?
    var shippingCharge: Int = 0
    var cardArray:[Int] = [1,2,3,5]
    var addressLoaded = false
    var walletPaymentIsSelected = false
    var codPaymentIsSelected = false

    //MARK: - Life Cycles -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllShippingAddressListApi()
        setCartData()
        NotificationCenter.default.removeObserver(self, name: Notification.Name("setWalletBalance"), object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(self.setWalletBalance),name:Notification.Name("setWalletBalance"), object: nil)
        self.setWalletBalance()
        self.walletBalanceErrorView.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (addressLoaded) {
            getAllShippingAddressListApi()
        }
        addressLoaded = true
    }
    
    //MARK: - Selectors -
    
    // Back Button Action
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    // Add New Address Button Action
    @IBAction func addNewAddressButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddAddressViewController") as! AddAddressViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // Wallet Radio Button Action
    @IBAction func walletAndCodRadioBtnAction(_ sender: UIButton) {
        if sender.tag == 1005 {
            if (cartList?.totalPrice ?? 0.0) > (walletData?.amount ?? 0.0) {
                walletBalanceErrorView.isHidden = false
                return
            } else {
                walletBalanceErrorView.isHidden = true
            }
            walletPaymentIsSelected = !walletPaymentIsSelected
            codPaymentIsSelected = !walletPaymentIsSelected
            
        } else if sender.tag == 1006 {
            codPaymentIsSelected = !codPaymentIsSelected
            walletPaymentIsSelected = !codPaymentIsSelected
        }
        codPaymentRadioButton.setImage(UIImage(named: codPaymentIsSelected ? "fillRadioBtn" : "blankRadioBtn"), for: .normal)
        codPaymentRadioButton.tintColor = codPaymentIsSelected ? UIColor.init(hexFromString: "2878B6") : UIColor.darkGray
        walletPaymentRadioButton.setImage(UIImage(named: walletPaymentIsSelected ? "fillRadioBtn" : "blankRadioBtn"), for: .normal)
        walletPaymentRadioButton.tintColor = walletPaymentIsSelected ? UIColor.init(hexFromString: "2878B6") : UIColor.darkGray
    }
    
    // Place Order Button Action
    @IBAction func placeOrderButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if let selectedAddress = self.selectedAddress {
            var param: Parameters = [
                "addressLine1": "\(selectedAddress.addressLine1 ?? "")",
                "addressLine2":"\(selectedAddress.addressLine2 ?? "")",
                "zipCode":"\(selectedAddress.zipCode ?? "")",
                "city": "\(selectedAddress.city ?? "")",
                "state":"\(selectedAddress.state ?? "")",
                "country":"\(selectedAddress.country ?? "")",
                "primaryContactNumber":"\(selectedAddress.primaryContactNumber ?? "")",
                "secondaryContactNumber":"\(selectedAddress.secondaryContactNumber ?? "")",
                
                "id": selectedAddress.id ?? "",
                "extensionNumber": "+91",
                "primary": false,
                "area": "Manali",
                "title": selectedAddress.title ?? "",
                "orderNoteDescription":"This is Order not done by customer"
            ]
            if walletPaymentIsSelected {
             param["paymentMethod"] = "WALLET"
//                "CARD"
            }
            if codPaymentIsSelected {
                param["paymentMethod"] = "COD"
            }
            
            print(param)
            showLoading()
            APIHelper.placeOrderAPI(params: param) { (success, response) in
                if !success {
                    dissmissLoader()
                    let message = response.message
                    print(message)
                    self.view.makeToast(message)
                }else {
                    dissmissLoader()
                    let data = response.response["data"]
                    self.orderList = OrderItems.init(json: data)
                    print(self.orderList?.orderNo ?? "")
                    let newVC = self.storyboard?.instantiateViewController(withIdentifier: "OrderSummaryViewController") as! OrderSummaryViewController
                    if let orderNo = self.orderList?.orderNo {
                        newVC.orderNo = orderNo
                    }
                    newVC.isPlaceOrder = true
                    self.navigationController?.pushViewController(newVC, animated: true)
                    let message = response.message
                    print(message)
                    NotificationCenter.default.post(name:  Notification.Name("viewWalletBalanceByIdApi"), object: self)
                }
            }
        }
    }

    //MARK:- Helper Functions -
    
    // Set Cart Data
    func setCartData() {
        for item in self.cartList?.cartItemDTOList ?? [] {
            guard let total = item.shippingCharge else { return }
            shippingCharge += total
        }
        print(shippingCharge)
        shippingChargesLbl.text = "\(shippingCharge)"
        subTotalLbl.text = cartList?.totalTaxableValue?.doubleToStringWithComma()
        gstLbl.text = ((cartList?.totalCgst ?? 0.0) + (cartList?.totalSgst ?? 0.0)).doubleToStringWithComma()
        totalLbl.text = cartList?.totalPrice?.doubleToStringWithComma()
    }
    
    // Set Wallet Balance
    @objc func setWalletBalance() {
        walletBalanceLbl.text = "₹\(walletData?.amount ?? 0.0)"
    }
    
}

//MARK: - Extensions -

//MARK: Api Call
extension CheckoutViewController {
    
    // Get All Shipping Address List Api
    func getAllShippingAddressListApi() {
        let params: Parameters = [
            "pageNo": page,
            "pageSize": 10,
            "sortBy": "createdAt",
            "asc": false
        ]
        print(params)
        showLoading()
        APIHelper.getAllShippingAddressApi(parameters: params) { (success, response) in
            if !success {
                dissmissLoader()
                let message = response.message
                myApp.window?.rootViewController?.view.makeToast(message)
            }else {
                dissmissLoader()
                let data = response.response["data"]
                self.shippingAddressList = AddressList.init(json: data)
                if (self.page == 0) {
                    self.addressListItems = self.shippingAddressList?.items ?? []
                } else{
                    self.addressListItems.append(contentsOf: self.shippingAddressList?.items ?? [])
                }
                self.selectedAddress = self.addressListItems.first
                self.totalCount = self.shippingAddressList?.totalItems ?? 0
                self.addressTableViewHeightConstraint.constant = self.addressListItems.count == 1 ? 120 : 240
                self.addressTableView.reloadData()
            }
        }
    }
    
    // Delete Address Api
    func deleteAddressAPI(id: String) {
        let params: Parameters = [
            "ids" : [id]
        ]
        print(params)
        showLoading()
        APIHelper.deleteAddressAPI(parameters: params) { (success, response) in
            if !success {
                dissmissLoader()
                let message = response.message
                myApp.window?.rootViewController?.view.makeToast(message)
            }else {
                dissmissLoader()
                let message = response.message
                print(message)
                self.addressTableView.reloadData()
                self.getAllShippingAddressListApi()
                myApp.window?.rootViewController?.view.makeToast(message)
            }
        }
    }
    
}

//MARK: TableView SetUp
extension CheckoutViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case addressTableView:
            return self.addressListItems.count
        default:
            break
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case addressTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "addressTableViewCell", for: indexPath) as! addressTableViewCell
            let item = self.addressListItems[indexPath.row]
            cell.addressItem = item
            if (selectedAddressIndex == indexPath.row) {
                cell.selectedButton.isHidden = false
                cell.mainView.layer.borderWidth = 1
                cell.mainView.layer.borderColor = #colorLiteral(red: 0.1568627451, green: 0.4705882353, blue: 0.7137254902, alpha: 1)
            } else {
                cell.selectedButton.isHidden = true
                cell.mainView.layer.borderWidth = 0
                cell.mainView.layer.borderColor = UIColor.clear.cgColor
            }
            cell.editButtonHandler = { sender in
                sender.tag = indexPath.row
                let newVC = self.storyboard?.instantiateViewController(withIdentifier: "AddAddressViewController") as! AddAddressViewController
                newVC.isEditAddress = true
                newVC.addressItem = item
                self.navigationController?.pushViewController(newVC, animated: true)
            }            
            cell.deleteButtonHandler = { sender in
                sender.tag = indexPath.row
                let alert = UIAlertController(title: "Delete Address", message: "Are you sure you want to remove address?", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default) { (action) in
                    if let id = item.id {
                        self.deleteAddressAPI(id: id)
                    }
                }
                let cancel = UIAlertAction(title: "Cancel", style: .default) { (action) in
                    self.dismiss(animated: true, completion: nil)
                }
                alert.addAction(cancel)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
            let clearView = UIView()
            clearView.backgroundColor = .clear // Whatever color you like
            cell.selectedBackgroundView = clearView
            return cell
        default:
            break
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch tableView {
        case addressTableView:
            selectedAddressIndex = indexPath.row
            let item = self.addressListItems[indexPath.row]
            self.selectedAddress = item
            tableView.reloadData()
        default:
            break
        }
    }
}

// MARK: ScrollView Setup
extension CheckoutViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let totalRecords = self.shippingAddressList?.items?.count ?? 0
        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 10.0 && /*totalRecords >= 10*/totalRecords < totalCount {
            if page < ((self.shippingAddressList?.totalPages ?? 0)-1) {
                page += 1
                self.getAllShippingAddressListApi()
            }
        }
    }
    
}
