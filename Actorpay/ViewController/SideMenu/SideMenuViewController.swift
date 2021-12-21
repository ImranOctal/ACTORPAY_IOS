//
//  SideMenuViewController.swift
//  Actorpay
//
//  Created by iMac on 02/12/21.
//

import UIKit
import AKSideMenu

final class SideMenuViewController: UIViewController {
        
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(UINib(nibName: "SideMenuTableViewCell", bundle: nil), forCellReuseIdentifier: "SideMenuTableViewCell")
         }
    }
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var userEmailLabel: UILabel!
    
    var sidemenuArray = [typeAliasStringDictionary]()
    var selectedObject = typeAliasStringDictionary()

    // MARK: - Life Cycle Function

    override public func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: Create Data Dic for Side menu
        let myOrders: typeAliasStringDictionary = [VAL_TITLE :"My Orders", VAL_IMAGE : "my_orders"]
        let walletStatement: typeAliasStringDictionary = [VAL_TITLE :"Wallet Statement", VAL_IMAGE : "wallet_statement"]
        let rewardsPoints: typeAliasStringDictionary = [VAL_TITLE :"My Loyalty/Rewards Points", VAL_IMAGE : "my_profile"]
        let referral: typeAliasStringDictionary = [VAL_TITLE :"Referral", VAL_IMAGE : "my_orders"]
        let availabelMoney: typeAliasStringDictionary = [VAL_TITLE :"View Available Money in Wallet", VAL_IMAGE : "my_orders"]
        let my_profile: typeAliasStringDictionary = [VAL_TITLE :"My Profile", VAL_IMAGE : "my_profile"]
        let changePassword: typeAliasStringDictionary = [VAL_TITLE :"Change Password", VAL_IMAGE : "my_profile"]
        let promo_offers: typeAliasStringDictionary = [VAL_TITLE :"Promo & Offers", VAL_IMAGE : "my_profile"]
        let changePaymentOption: typeAliasStringDictionary = [VAL_TITLE :"Change Payment Option", VAL_IMAGE : "change_payment_option"]
        let settings: typeAliasStringDictionary = [VAL_TITLE :"Settings", VAL_IMAGE : "settings"]
        let more: typeAliasStringDictionary = [VAL_TITLE :"More", VAL_IMAGE : "more"]
        
        let logout: typeAliasStringDictionary = [VAL_TITLE :"Logout", VAL_IMAGE : "logout"]
        //TODO: CHANGE ORDER OF SIDE MENU CHANGE HERE
        sidemenuArray = [myOrders,walletStatement,rewardsPoints,referral,availabelMoney,my_profile,changePassword,promo_offers,changePaymentOption,settings,more,logout]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
}

extension SideMenuViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.sideMenuViewController?.dismiss(animated: true, completion: nil)
        self.sideMenuViewController?.hideMenuViewController()
        switch indexPath.row {
        case 0:
            let secondVC = storyboard?.instantiateViewController(withIdentifier: "MyOrdersViewController") as! MyOrdersViewController
            self.navigationController?.pushViewController(secondVC, animated: true)
        case 1:
            let secondVC = storyboard?.instantiateViewController(withIdentifier: "WalletStatementViewController") as! WalletStatementViewController
            self.navigationController?.pushViewController(secondVC, animated: true)
        case 2:
            let secondVC = storyboard?.instantiateViewController(withIdentifier: "RewardPointsViewController") as! RewardPointsViewController
            self.navigationController?.pushViewController(secondVC, animated: true)
        case 3:
            //Referral
            obj_AppDelegate.window?.rootViewController?.view.makeToast("Coming Soon")
            break
        case 4:
            //Available Money
            obj_AppDelegate.window?.rootViewController?.view.makeToast("Coming Soon")
            break
        case 5:
            //My Profile
            isProfileView = true
            let newVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeNav") as! UINavigationController
            myApp.window?.rootViewController = newVC
            
//            obj_AppDelegate.window?.rootViewController?.view.makeToast("Coming Soon")
            
        case 6:
            //Change Password
            if let opo = obj_AppDelegate.window?.rootViewController {
            let popOverConfirmVC = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordViewController") as! ChangePasswordViewController
            obj_AppDelegate.window?.rootViewController?.addChild(popOverConfirmVC)
            popOverConfirmVC.view.frame = opo.view.frame
            opo.view.center = popOverConfirmVC.view.center
            opo.view.addSubview(popOverConfirmVC.view)
            popOverConfirmVC.didMove(toParent: self)
            }
        case 7:
            //Promo and Offers
            obj_AppDelegate.window?.rootViewController?.view.makeToast("Coming Soon")
            break
        case 8:
            let newVC = self.storyboard?.instantiateViewController(withIdentifier: "RemittanceViewController") as! RemittanceViewController
            self.navigationController?.pushViewController(newVC, animated: true)
        case 9:
            //Settings
            obj_AppDelegate.window?.rootViewController?.view.makeToast("Coming Soon")
            break
        case 10:
            let secondVC = storyboard?.instantiateViewController(withIdentifier: "MoreViewController") as! MoreViewController
            self.navigationController?.pushViewController(secondVC, animated: true)
        case 11:
            // Logout
            let alert = UIAlertController(title: "Logout", message: "Are you sure you want to Logout??", preferredStyle: .alert)
            let ok = UIAlertAction(title: "ok", style: .default) { (action) in
                AppManager.shared.token = ""
                AppManager.shared.userId = ""
                let newVC = self.storyboard?.instantiateViewController(withIdentifier: "loginVC") as! UINavigationController
                myApp.window?.rootViewController = newVC
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(ok)
            alert.addAction(cancel)
            obj_AppDelegate.window?.rootViewController?.present(alert, animated: true, completion: nil)
//            break
        default:
            break
        }
    }
}

extension SideMenuViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection sectionIndex: Int) -> Int {
        return sidemenuArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuTableViewCell") as! SideMenuTableViewCell
        cell.selectionStyle = .none
        let dict: typeAliasStringDictionary = sidemenuArray[indexPath.row]
        cell.imgSideBar.image = UIImage(named: dict[VAL_IMAGE]!)
        cell.lblSideBarName.text = NSLocalizedString(dict[VAL_TITLE]!, comment: "")
        cell.viewWithTag(1001)?.isHidden = indexPath.row == 10 ? false : true
       /* if dict == selectedObject {
            cell.imgSideBar.tintColor = primaryColor
            cell.lblSideBarName.textColor = primaryColor
        } else{
            cell.imgSideBar.tintColor = .black
            cell.lblSideBarName.textColor = .black
        }*/
        
        return cell
        
    }
}
