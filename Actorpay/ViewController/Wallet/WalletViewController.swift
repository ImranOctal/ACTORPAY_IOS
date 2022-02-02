//
//  WalletViewController.swift
//  Actorpay
//
//  Created by iMac on 03/12/21.
//

import UIKit
import Alamofire

class WalletViewController: UIViewController {

    //MARK: - Properties -
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstaint: NSLayoutConstraint!
    
    var productArray = [1,2,3,4,5,6,7]
    var walletData : Wallet?
    
    //MARK: - Life Cycle Function -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        topCorner(bgView: mainView, maskToBounds: true)
        tableView.delegate = self
        tableView.dataSource = self
        tableViewHeightManage()
        self.getUserWalletDetailsApi()
        tableView.addPullToRefresh {
            self.getUserWalletDetailsApi()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        selectedTabIndex = self.tabBarController?.selectedIndex ?? 0
    }
    
    @IBAction func addMoneyButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddMoneyViewController") as! AddMoneyViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- Helper Functions -
    
    //tableView Height Manage
    func tableViewHeightManage() {
        tableViewHeightConstaint.constant = (productArray.count == 0 ? 125.0 : CGFloat( 120 * productArray.count))
    }
    
}

//MARK: - Extensions -

//MARK: Api Call
extension WalletViewController {
    
    // Get User Wallet Details Api
    func getUserWalletDetailsApi() {
        let params: Parameters = [
            "userId": AppManager.shared.userId
        ]
        showLoading()
        APIHelper.getUserWalletDetailsApi(params: params) { (success, response) in
            self.tableView.pullToRefreshView.stopAnimating()
            if !success {
                dissmissLoader()
                let message = response.message
                print(message)
//                myApp.window?.rootViewController?.view.makeToast(message)
            }else {
                dissmissLoader()
                let data = response.response["data"]
                self.walletData = Wallet.init(json: data)
                let message = response.message
                print(message)
//                myApp.window?.rootViewController?.view.makeToast(message)
                self.tableView.reloadData()
            }
        }
    }
}


//MARK: TableView SetUp
extension WalletViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WalletStatementTableViewCell", for: indexPath) as! WalletStatementTableViewCell
        cell.clearSelectedBackGround()
        return cell
    }    
}
