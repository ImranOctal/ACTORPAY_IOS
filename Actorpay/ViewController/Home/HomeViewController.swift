//
//  HomeViewController.swift
//  Actorpay
//
//  Created by iMac on 02/12/21.
//

import UIKit
import AKSideMenu
import Alamofire
import PopupDialog
//import SwiftQRScanner

class HomeViewController: UIViewController {
    
    //MARK: - Properties -

    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var transactionView: UIView!
    @IBOutlet weak var transactionTableView: UITableView!
    
    var category:[Category] = [
        Category(title: "Add Money", icon: UIImage(named: "add_money")),
        Category(title: "Send Money", icon: UIImage(named: "send_money")),
        Category(title: "Mobile & DTH", icon: UIImage(named: "smartphone")),
        Category(title: "Utility Bill", icon: UIImage(named: "bill")),
        Category(title: "Add Money", icon: UIImage(named: "add_money")),
        Category(title: "Send Money", icon: UIImage(named: "send_money")),
        Category(title: "Mobile & DTH", icon: UIImage(named: "smartphone")),
        Category(title: "Utility Bill", icon: UIImage(named: "bill"))
        
    ]
    let contactHeaderHeight: CGFloat = 32
    var transactionArray:[Int] = [1,2,3]
    
    //MARK: - Life Cycles -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topCorner(bgView: transactionView, maskToBounds: true)
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        transactionTableView.delegate = self
        transactionTableView.dataSource = self
        transactionTableView.register(UINib(nibName: "TransactionTableViewCell", bundle: nil), forCellReuseIdentifier: "TransactionTableViewCell")
        transactionTableView.estimatedRowHeight = 70
        transactionTableView.rowHeight = UITableView.automaticDimension
        getUserDetailsApi()
        NotificationCenter.default.removeObserver(self, name: Notification.Name("getUserDetail"), object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(self.getUserDetailsApi),name:Notification.Name("getUserDetail"), object: nil)
        getAllCategories(pageSize: 10)
        self.viewWalletBalanceByIdApi()
        NotificationCenter.default.removeObserver(self, name: Notification.Name("viewWalletBalanceByIdApi"), object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(self.viewWalletBalanceByIdApi),name:Notification.Name("viewWalletBalanceByIdApi"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        selectedTabIndex = self.tabBarController?.selectedIndex ?? 0
    }
    
    //MARK: - Selectors-

    // Menu Button Action
    @IBAction func menuButtonAction(_ sender: UIButton){
        self.view.endEditing(true)
        self.sideMenuViewController?.presentLeftMenuViewController()
    }
    
    // Notification Button Action
    @IBAction func notificationButtonAction(_ sender: UIButton){
        self.view.endEditing(true)
        let newVC = self.storyboard?.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    
}

//MARK: - Extensions -

//MARK: Api Call
extension HomeViewController {
    
    // Get User Detail Api
    @objc func getUserDetailsApi(){
        showLoading()
        APIHelper.getUserDetailsById(id: AppManager.shared.userId) { (success, response) in
            if !success {
                dissmissLoader()
                let message = response.message
                print(message)
                let customV = self.storyboard?.instantiateViewController(withIdentifier: "CustomAlertViewController") as! CustomAlertViewController
                let popup = PopupDialog(viewController: customV, buttonAlignment: .horizontal, transitionStyle: .bounceUp, tapGestureDismissal: true)
                customV.setUpCustomAlert(titleStr: "Logout", descriptionStr: "Session Expire", isShowCancelBtn: true)
                customV.customAlertDelegate = self
                self.present(popup, animated: true, completion: nil)
            }else {
                dissmissLoader()
                let data = response.response["data"]
                user = User.init(json: data)
                NotificationCenter.default.post(name:  Notification.Name("setupUserData"), object: self)
                NotificationCenter.default.post(name:  Notification.Name("setProfileData"), object: self)
                
            }
        }
    }
    
    // Get All Category Api
    func getAllCategories(pageSize: Int) {
        showLoading()
        let params: Parameters = [
            "pageSize":pageSize,
            "filterByIsActive":true,
            "sortBy":"name",
            "asc":true
            
        ]
        APIHelper.getAllCategoriesAPI(parameters: params) { (success, response) in
            if !success {
                dissmissLoader()
                let message = response.message
                self.view.makeToast(message)
            }else {
                dissmissLoader()
                let data = response.response["data"]
                categoryList = CategoryList.init(json: data)
                let message = response.message
                print(message)
            }
        }
    }
    
    // Get User Wallet Details Api
    @objc func viewWalletBalanceByIdApi() {
        showLoading()
        APIHelper.viewWalletBalanceByIdApi(parameters: [:], userId: AppManager.shared.userId) { (success, response) in
            if !success {
                dissmissLoader()
                let message = response.message
                print(message)
                myApp.window?.rootViewController?.view.makeToast(message)
            }else {
                dissmissLoader()
                let data = response.response["data"]
                walletData = Wallet.init(json: data)
                let message = response.message
                print(message)
//                myApp.window?.rootViewController?.view.makeToast(message)
                NotificationCenter.default.post(name:  Notification.Name("setProfileData"), object: self)
                NotificationCenter.default.post(name:  Notification.Name("setWalletBalance"), object: self)
                NotificationCenter.default.post(name:  Notification.Name("setWalletBalanceInWalletStatement"), object: self)
            }
        }
    }
}

//MARK: Collection View SetUp
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return category.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
        cell.iconImageView.image = category[indexPath.row].icon
        cell.titleLabel.text = category[indexPath.row].title
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddMoneyViewController") as! AddMoneyViewController
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
}

//MARK: Tableview Setup
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTableViewCell", for: indexPath) as! TransactionTableViewCell
        if indexPath.row == 0 {
            topCorners(bgView: cell.mainView, cornerRadius: 15, maskToBounds: true)
            cell.sepratorView.isHidden = false
        }else if ((indexPath.row) == (transactionArray.count-1)){
            bottomCorner(bgView: cell.mainView, cornerRadius: 15, maskToBounds: true)
            cell.sepratorView.isHidden = true
        }else{
            topCorners(bgView: cell.mainView, cornerRadius: 0, maskToBounds: true)
            bottomCorner(bgView: cell.mainView, cornerRadius: 0, maskToBounds: true)
            cell.sepratorView.isHidden = false
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50))
        let label = UILabel(frame: CGRect(x: 20, y: -5, width: tableView.frame.size.width, height: 30))
        switch section {
        case 0:
            label.text = "Today Transactions"
        case 1:
            label.text = "Yesterday Transactions"
        default:
            label.text = ""
        }
//        label.font = UIFont.init(name: "Poppins-Medium", size: 10)
        label.font = .systemFont(ofSize: 12)

        label.textColor = UIColor.init(hexFromString: "#8C8C8C")
        view.backgroundColor = .white
        self.view.addSubview(view)
        view.addSubview(label)

        return view
    }
}


//MARK: - CustomAlert Delegate Methods -
extension HomeViewController: CustomAlertDelegate {
    
    func okButtonclick() {
        AppManager.shared.token = ""
        AppManager.shared.userId = ""
        let newVC = self.storyboard?.instantiateViewController(withIdentifier: "loginVC") as! UINavigationController
        myApp.window?.rootViewController = newVC
    }
    
    func cancelButtonClick() {
        self.dismiss(animated: true, completion: nil)
    }
}
