//
//  MyOrdersViewController.swift
//  Actorpay
//
//  Created by iMac on 06/12/21.
//

import UIKit
import Alamofire

class MyOrdersViewController: UIViewController {
    
    //MARK: - Properties -

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var myOrders: OrderList?
    var orderList: [OrderItems] = []
    var filterOrderParm: Parameters?
    var page = 0
    var totalCount = 10
    
    //MARK: - Life Cycles -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        topCorner(bgView: mainView, maskToBounds: true)
        setUpTblView()
        self.getOrderListApi()
        tableView.addPullToRefresh(actionHandler: {
            self.page = 0
            self.getOrderListApi()
        })
        NotificationCenter.default.removeObserver(self, name: Notification.Name("reloadOrderListApi"), object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(self.reloadOrderListApi),name:Notification.Name("reloadOrderListApi"), object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //MARK: - Selectors -

    // SideMenu Button Action
    @IBAction func menuButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.sideMenuViewController?.presentLeftMenuViewController()
    }
    
    // Filter Button Action
    @IBAction func filterButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let newVC = (self.storyboard?.instantiateViewController(withIdentifier: "FilterOrderViewController") as? FilterOrderViewController)!
        newVC.view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        self.definesPresentationContext = true
        self.providesPresentationContextTransitionStyle = true
        newVC.modalPresentationStyle = .overCurrentContext
        newVC.filterOrderParm = filterOrderParm
        newVC.setFilterData()
        newVC.completion = { param in
            print(param ?? [:])
            self.page = 0
            self.filterOrderParm = param
            self.getOrderListApi()
        }
        self.navigationController?.present(newVC, animated: true, completion: nil)
    }
    
    //MARK: - Helper Functions -
    
    // tableView SetUp
    func setUpTblView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    // Reload Order List Api
    @objc func reloadOrderListApi() {
        self.getOrderListApi()
    }
    
}

//MARK: - Extensions -

//MARK: Api Call
extension MyOrdersViewController {
    // Get All Order APi
    func getOrderListApi(parameter: Parameters? = nil, bodyParameter:Parameters? = nil) {
        var parameters = Parameters()
        if parameter == nil {
            parameters["pageNo"] = page
            parameters["pageSize"] = 10
        } else{
            page = 0
            if let parameter = parameter {
                parameters = parameter
            }
            parameters["pageNo"] = page
            parameters["pageSize"] = 10
        }
        
        var bodyParam = Parameters()
        if bodyParameter == nil {
            if let bodyParameter = filterOrderParm {
                bodyParam = bodyParameter
            }
        } else {
            if let bodyParameter = bodyParameter {
                bodyParam = bodyParameter
            }
        }
        showLoading()
        APIHelper.getAllOrders(urlParameters: parameters,bodyParameter: bodyParam) { (success, response) in
            self.tableView.pullToRefreshView?.stopAnimating()
            if !success {
                dissmissLoader()
                let message = response.message
                myApp.window?.rootViewController?.view.makeToast(message)
            }else {
                dissmissLoader()
                let data = response.response["data"]
                self.myOrders = OrderList.init(json: data)
                if self.page == 0 {
                    self.orderList = OrderList.init(json: data).items ?? []
                } else{
                    self.orderList.append(contentsOf: OrderList.init(json: data).items ?? [])
                }
                self.totalCount = self.myOrders?.totalItems ?? 0
                let message = response.message
                print(message)
//                myApp.window?.rootViewController?.view.makeToast(message)
                self.tableView.reloadData()
            }
        }
    }
    
    // Update Order Status Api
    func updateOrderStatusApi(orderNo: String) {
        let params: Parameters = [
            "orderNo": orderNo
        ]
        showLoading()
        APIHelper.updateOrderStatusApi(params: params) { (success, response) in
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

//MARK: TableView SetUp
extension MyOrdersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.orderList.count == 0 {
            tableView.setEmptyMessage("No Data Found.")
        }else {
            tableView.restore()
        }
        return self.orderList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyOrderCell", for: indexPath) as! MyOrderCell
        cell.orderItemDtos = orderList[indexPath.row].orderItemDtos
        cell.imgCollectionView.reloadData()
        cell.item = orderList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newVC = self.storyboard?.instantiateViewController(withIdentifier: "OrderSummaryViewController") as! OrderSummaryViewController
        newVC.orderNo = orderList[indexPath.row].orderNo ?? ""
        self.navigationController?.pushViewController(newVC, animated: true)
    }
}

// MARK: ScrollView Setup
extension MyOrdersViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let totalRecords = orderList.count 
        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 10.0 && totalRecords < totalCount {
            if page < ((self.myOrders?.totalPages ?? 0)-1) {
                page += 1
                self.getOrderListApi()
            }
        }
    }
}
