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
    @IBOutlet weak var addressLine1Lbl: UILabel!
    @IBOutlet weak var addressLine2Lbl: UILabel!
    @IBOutlet weak var countryAndCityLbl: UILabel!
    @IBOutlet weak var licenceNoLbl: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var contactNoLbl: UILabel!
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var buttonAction: UIButton!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var orderStatusView: UIView!
    @IBOutlet weak var notesTblView: UITableView! {
        didSet {
            self.notesTblView.delegate = self
            self.notesTblView.dataSource = self
        }
    }
    @IBOutlet weak var notesTblViewHeightConst: NSLayoutConstraint!
    
    var orderNo = ""
    var orderItems: OrderItems?
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
        NotificationCenter.default.removeObserver(self, name: Notification.Name("getOrderDetailsApi"), object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(self.getOrderDetailsApi),name:Notification.Name("getOrderDetailsApi"), object: nil)
    }
    
    //MARK: - Selectors -
    
    //Back Button Action
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popToRootViewController(animated: true)
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
    
    // Add Order Note Button Action
    @IBAction func addNoteBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let newVC = (self.storyboard?.instantiateViewController(withIdentifier: "AddNoteViewController") as? AddNoteViewController)!
        newVC.orderItems = self.orderItems
        self.definesPresentationContext = true
        self.providesPresentationContextTransitionStyle = true
        newVC.modalPresentationStyle = .overCurrentContext
        self.navigationController?.present(newVC, animated: true, completion: nil)
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
        orderNumberLbl.text = orderItems?.orderNo ?? ""
        orderDateAndTimeLbl.text = "Order Date & Time: \(orderItems?.createdAt?.toFormatedDate(from: "yyyy-MM-dd hh:mm", to: "dd MMM yyyy HH:MM") ?? "")"
        addressLine1Lbl.text = orderItems?.shippingAddressDTO?.addressLine1 ?? ""
        addressLine2Lbl.text = orderItems?.shippingAddressDTO?.addressLine2 ?? ""
        countryAndCityLbl.text = "\(orderItems?.shippingAddressDTO?.city ?? "")\n\(orderItems?.shippingAddressDTO?.country ?? "")"
        emailLabel.text = orderItems?.merchantDTO?.email ?? ""
        licenceNoLbl.text = orderItems?.merchantDTO?.licenceNumber ?? ""
        contactNoLbl.text = orderItems?.merchantDTO?.contactNumber ?? ""
        businessNameLabel.text = orderItems?.merchantDTO?.businessName
        statusLbl.text = orderItems?.orderStatus ?? ""
        orderStatusView.layer.borderColor = getStatus(stausString: orderItems?.orderStatus ?? "").cgColor
        statusLbl.textColor = getStatus(stausString: orderItems?.orderStatus ?? "")
    }
    
}

//MARK:- Extensions -

//MARK: Api Call
extension OrderSummaryViewController {
    
    // get Order Details Api
    @objc func getOrderDetailsApi() {
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
                self.tblViewHeightConst.constant = CGFloat(120 * (self.orderItems?.orderItemDtos?.count ?? 0))
                self.setUpOrderDetailsData()
                self.notesTblView.reloadData()
                self.notesTblViewHeightConst.constant = CGFloat((self.orderItems?.orderNotesDtos?.count ?? 0) * 83)
                self.tblView.reloadData()
            }
        }
    }
    
}

//MARK: Table View SetUp
extension OrderSummaryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case tblView:
            return orderItems?.orderItemDtos?.count ?? 0
        case notesTblView:
            if self.orderItems?.orderNotesDtos?.count == 0 {
                notesTblView.setEmptyMessage("No Data Found.")
            }else {
                notesTblView.restore()
            }
            return self.orderItems?.orderNotesDtos?.count ?? 0
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case tblView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderItemTableViewCell", for: indexPath) as! OrderItemTableViewCell
            let item = orderItems?.orderItemDtos?[indexPath.row]
            cell.item = item
            cell.menuButtonHandler = {
                cell.setUpCancelOrderDropDown()
            }
            cell.cancelOrderHandler = { status in
                let newVC = self.storyboard?.instantiateViewController(withIdentifier: "CancelOrderViewController") as! CancelOrderViewController
                newVC.status = status
                newVC.orderItems = self.orderItems
                newVC.orderItemDtos = item
                self.navigationController?.pushViewController(newVC, animated: true)
            }
            return cell
        case notesTblView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderNoteTableViewCell", for: indexPath) as! OrderNoteTableViewCell
            let item = orderItems?.orderNotesDtos?[indexPath.row]
            cell.item = item
            return cell
        default:
            return UITableViewCell()
        }
        
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        switch tableView {
//        case notesTblView:
//            notesTblViewHeightConst.constant = cell.contentView.frame.height * CGFloat(orderItems?.orderNotesDtos?.count ?? 0)
//        default:
//            break
//        }
//    }
    
}

//MARK: CustomAlert Delegate Methods
extension OrderSummaryViewController: CustomAlertDelegate {
    
    func okButtonclick() {
        print("Cancel Order Button Tapped")
    }
    
    func cancelButtonClick() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
