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
import SVPullToRefresh

class OrderSummaryViewController: UIViewController {
    
    //MARK: - Properties -
    
    @IBOutlet weak var orderSummaryScrollView: UIScrollView!
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
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var orderStatusView: UIView!
    @IBOutlet weak var notesTblView: UITableView! {
        didSet {
            self.notesTblView.delegate = self
            self.notesTblView.dataSource = self
        }
    }
    @IBOutlet weak var notesTblViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var addNoteView: UIView!
    @IBOutlet weak var paymentMethodLbl: UILabel!
    @IBOutlet weak var paymentMethodView: UIView!
    
    var orderNo = ""
    var orderItems: OrderItems?
    var filterNoteArr: [OrderNotesDtos] = []
    var isPlaceOrder = false
    
    //MARK: - Life Cycles -

    override func viewDidLoad() {
        super.viewDidLoad()
        statusView.isHidden = !isPlaceOrder
        buttonView.isHidden = !isPlaceOrder
        addNoteView.isHidden = isPlaceOrder
        topCorner(bgView: bgView, maskToBounds: true)
        self.getOrderDetailsApi()
        self.orderSummaryScrollView.addPullToRefresh {
            self.getOrderDetailsApi()
        }
        self.setUpTableView()
        NotificationCenter.default.removeObserver(self, name: Notification.Name("getOrderDetailsApi"), object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(self.getOrderDetailsApi),name:Notification.Name("getOrderDetailsApi"), object: nil)
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        DispatchQueue.main.async {
            self.notesTblViewHeightConst.constant = self.notesTblView.contentSize.height
        }
    }
    
    //MARK: - Selectors -
    
    //Back Button Action
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popToRootViewController(animated: true)
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
    
    // Check Orders Button Action
    @IBAction func checkOrdersBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if let myOrderVC = storyboard?.instantiateViewController(withIdentifier: "MyOrdersViewController") {
            let contentViewController = UINavigationController(rootViewController: myOrderVC)
            sideMenuViewController?.setContentViewController(contentViewController, animated: true)
            sideMenuViewController?.hideMenuViewController()
        }
    }
    
    // Continue Shopping Button Action
    @IBAction func continueShoppingBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let newVC = navigationController!.viewControllers.filter { $0 is ProductListViewController }.first!
        self.navigationController?.popToViewController(newVC, animated: true)
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
        statusLbl.text = (orderItems?.orderStatus ?? "").replacingOccurrences(of: "_", with: " ", options: .literal, range: nil)
        orderStatusView.layer.borderColor = getStatus(stausString: orderItems?.orderStatus ?? "").cgColor
        statusLbl.textColor = getStatus(stausString: orderItems?.orderStatus ?? "")
        if orderItems?.paymentMethod != nil {
            paymentMethodLbl.text = orderItems?.paymentMethod
        } else {
            paymentMethodView.isHidden = true
        }
        
    }
    
}

//MARK:- Extensions -

//MARK: Api Call
extension OrderSummaryViewController {
    
    // get Order Details Api
    @objc func getOrderDetailsApi() {
        showLoading()
        APIHelper.getOrderDetailsApi(orderNo: orderNo) { (success, response) in
            self.orderSummaryScrollView.pullToRefreshView?.stopAnimating()
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
                self.filterNoteArr = (self.orderItems?.orderNotesDtos ?? []).filter({$0.orderNoteDescription != nil})
                self.notesTblView.reloadData()
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
            if self.filterNoteArr.count == 0 {
                notesTblView.setEmptyMessage("No Data Found.")
            } else {
                notesTblView.restore()
            }
            return self.filterNoteArr.count
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
                if status == "Raise Dispute" {
                    let newVC = self.storyboard?.instantiateViewController(withIdentifier: "RaiseDisputeViewController") as! RaiseDisputeViewController
                    newVC.status = status
                    newVC.orderItems = self.orderItems
                    newVC.orderItemDtos = item
                    self.navigationController?.pushViewController(newVC, animated: true)
                }else{
                    let newVC = self.storyboard?.instantiateViewController(withIdentifier: "CancelOrderViewController") as! CancelOrderViewController
                    newVC.status = status
                    newVC.orderItems = self.orderItems
                    newVC.orderItemDtos = item
                    self.navigationController?.pushViewController(newVC, animated: true)
                }
            }
            return cell
        case notesTblView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderNoteTableViewCell", for: indexPath) as! OrderNoteTableViewCell
            let item = filterNoteArr[indexPath.row]
            cell.item = item
            return cell
        default:
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch tableView {
        case notesTblView:
            self.viewWillLayoutSubviews()
        default:
            break
        }
    }
    
}
