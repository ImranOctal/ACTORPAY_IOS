//
//  ManageAddressViewController.swift
//  Actorpay
//
//  Created by iMac on 03/01/22.
//

import UIKit
import Alamofire
import PopupDialog

class ManageAddressViewController: UIViewController {
    
    //MARK: - Properties -
    
    @IBOutlet weak var tblView: UITableView!
    
    var shippingAddressList: AddressList?
    var page = 0
    var totalCount = 10
    var addressListItems:[AddressItems] = []
    var shippingAddressID = ""
    
    //MARK: - Life Cycles -
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tblView.addPullToRefresh {
            self.page = 0
            self.getAllShippingAddressListApi()
        }
        self.tblView.dataSource = self
        self.tblView.delegate = self
        self.getAllShippingAddressListApi()        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("getAllShippingAddressListApi"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getAllShippingAddressListApi), name: NSNotification.Name("getAllShippingAddressListApi"), object: nil)
    }
    
    //MARK: - Selectors -
    
    //Back Button Action
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    // Add Address Button ACtion
    @IBAction func addAddresssButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddAddressViewController") as! AddAddressViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Helper Functions -
    
    // Get All Shipping Address List Api
    @objc func getAllShippingAddressListApi() {
        let params: Parameters = [
            "pageNo": page,
            "pageSize": 10,
            "sortBy": "createdAt",
            "asc": false
        ]
        print(params)
        showLoading()
        APIHelper.getAllShippingAddressApi(parameters: params) { (success, response) in
            self.tblView.pullToRefreshView?.stopAnimating()
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
                
//                for item in self.shippingAddressList?.items ?? [] {
//                    self.addressListItems.append(item)
//                }
                print(self.addressListItems.count)
                self.totalCount = self.shippingAddressList?.totalItems ?? 0
                self.tblView.reloadData()
            }
        }
    }
    
    // Delete Address Api
    func deleteAddressAPI(id: String) {
        /*let params: Parameters = [
            "ids" : [id]
        ]
        print(params)*/
        showLoading()
        APIHelper.deleteAddressAPI(id: id) { (success, response) in
            if !success {
                dissmissLoader()
                let message = response.message
                myApp.window?.rootViewController?.view.makeToast(message)
            }else {
                dissmissLoader()
                let message = response.message
                print(message)
                self.getAllShippingAddressListApi()
                self.tblView.reloadData()
                myApp.window?.rootViewController?.view.makeToast(message)
            }
        }
    }
}

//MARK: - Extensions -

//MARK: Table View Setup
extension ManageAddressViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.addressListItems.count == 0 {
            tableView.setEmptyMessage("No Data Found")
        }else{
            tableView.restore()
        }
        return self.addressListItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ManageAddressTableViewCell", for: indexPath) as! ManageAddressTableViewCell
        let item = self.addressListItems[indexPath.row]
        cell.nameLbl.text = item.title
        cell.addressLbl.text = "\(item.addressLine1 ?? "") \n \(item.addressLine2 ?? "") \n \(item.city ?? "")"
        cell.contactNoLbl.text = item.primaryContactNumber
        cell.deleteButtonHandler = { sender in
            sender.tag = indexPath.row
            if let id = item.id {
                self.shippingAddressID = id
            }
            let customV = self.storyboard?.instantiateViewController(withIdentifier: "CustomAlertViewController") as! CustomAlertViewController
            let popup = PopupDialog(viewController: customV, buttonAlignment: .horizontal, transitionStyle: .bounceUp, tapGestureDismissal: true)
            customV.setUpCustomAlert(titleStr: "Delete Address", descriptionStr: "Are you sure you want to remove address?", isShowCancelBtn: false)
            customV.customAlertDelegate = self
            self.present(popup, animated: true, completion: nil)
        }
        cell.editButtonHandler = {
            let newVC = self.storyboard?.instantiateViewController(withIdentifier: "AddAddressViewController") as! AddAddressViewController
            newVC.isEditAddress = true
            newVC.addressItem = item
            self.navigationController?.pushViewController(newVC, animated: true)
        }
        return cell
    }
}

// MARK: ScrollView Setup
extension ManageAddressViewController: UIScrollViewDelegate{
    
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

//MARK: CustomAlert Delegate Methods
extension ManageAddressViewController: CustomAlertDelegate {
    
    func okButtonclick() {
        self.deleteAddressAPI(id: shippingAddressID)
        self.dismiss(animated: true, completion: nil)
    }
    
    func cancelButtonClick() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
