//
//  WalletStatementViewController.swift
//  Actorpay
//
//  Created by iMac on 06/12/21.
//

import UIKit
import Alamofire
import Lottie

class WalletStatementViewController: UIViewController {

    //MARK: - Properties -
   
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.tableView.delegate = self
            self.tableView.dataSource = self
        }
    }
    @IBOutlet weak var emptyMessageView: UIView!
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var walletBalanceLbl: UILabel!
    
    var walletList: WalletList?
    var walletItems: [WalletItems] = []
    var filterOrderParm: Parameters?
    var page = 0
    var totalCount = 10
    
    //MARK: - Life Cycle Functions -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        topCorner(bgView: mainView, maskToBounds: true)
        self.walletTranscationApi()
        self.setEmptyCartLottieAnimation()
        NotificationCenter.default.removeObserver(self, name: Notification.Name("setWalletBalanceInWalletStatement"), object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(self.setWalletBalanceInWalletStatement),name:Notification.Name("setWalletBalanceInWalletStatement"), object: nil)
        self.setWalletBalanceInWalletStatement()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }

    //MARK: - Selectors -
    
    // Menu Button Action
    @IBAction func menuButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.sideMenuViewController?.presentLeftMenuViewController()
    }
    
    // Filter Button Action
    @IBAction func filterButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let newVC = (self.storyboard?.instantiateViewController(withIdentifier: "WalletFilterViewController") as? WalletFilterViewController)!
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
            self.walletTranscationApi()
        }
        self.navigationController?.present(newVC, animated: true, completion: nil)
    }
    
    //MARK: - Helper Functions -
    
    // Set Empty Cart Lottie Animation
    func setEmptyCartLottieAnimation() {
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.5
        animationView.play()
    }
    
    // Set Wallet Balance
    @objc func setWalletBalanceInWalletStatement() {
        walletBalanceLbl.text = "₹ \(walletData?.amount ?? 0.0)"
    }
        
}

//MARK: - Extension -

//MARK: Api Call
extension WalletStatementViewController {
    
    // walletTranscationApi
    func walletTranscationApi(parameter: Parameters? = nil, bodyParameter:Parameters? = nil) {
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
        APIHelper.walletTranscationApi(urlParameters: parameters,bodyParameter: bodyParam) { (success, response) in
            self.tableView.pullToRefreshView?.stopAnimating()
            if !success {
                dissmissLoader()
                let message = response.message
                myApp.window?.rootViewController?.view.makeToast(message)
            }else {
                dissmissLoader()
                let data = response.response["data"]
                self.walletList = WalletList.init(json: data)
                if self.page == 0 {
                    self.walletItems = WalletList.init(json: data).items ?? []
                } else{
                    self.walletItems.append(contentsOf: WalletList.init(json: data).items ?? [])
                }
                self.totalCount = self.walletList?.totalItems ?? 0
                let message = response.message
                print(message)
//                myApp.window?.rootViewController?.view.makeToast(message)
                if self.walletItems.count == 0 {
                    self.emptyMessageView.isHidden = false
                } else {
                    self.emptyMessageView.isHidden = true
                }
                self.tableView.reloadData()
            }
        }
    }
}

//MARK: TableView Setup
extension WalletStatementViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return walletItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WalletTransactionTableViewCell", for: indexPath) as! WalletTransactionTableViewCell
        let item = walletItems[indexPath.row]
        cell.item = item
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        let newVC = self.storyboard?.instantiateViewController(withIdentifier: "TransactionDetailsViewController") as! TransactionDetailsViewController
        newVC.walletItems = walletItems[indexPath.row]
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    
}

// MARK: ScrollView Setup
extension WalletStatementViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let totalRecords = walletItems.count
        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 10.0 && totalRecords < totalCount {
            if page < ((self.walletList?.totalPages ?? 0)-1) {
                page += 1
                self.walletTranscationApi()
            }
        }
    }
    
}
