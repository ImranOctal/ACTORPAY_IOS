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
        let myProfile: typeAliasStringDictionary = [VAL_TITLE :"My Profile", VAL_IMAGE : "my_profile"]
        let walletStatement: typeAliasStringDictionary = [VAL_TITLE :"Wallet Statement", VAL_IMAGE : "wallet_statement"]
        let myOrders: typeAliasStringDictionary = [VAL_TITLE :"My Orders", VAL_IMAGE : "my_orders"]
        let changePaymentOption: typeAliasStringDictionary = [VAL_TITLE :"Change Payment Option", VAL_IMAGE : "change_payment_option"]
        let settings: typeAliasStringDictionary = [VAL_TITLE :"Settings", VAL_IMAGE : "settings"]
        let more: typeAliasStringDictionary = [VAL_TITLE :"More", VAL_IMAGE : "more"]
        
        let logout: typeAliasStringDictionary = [VAL_TITLE :"Logout", VAL_IMAGE : "logout"]
        //TODO: CHANGE ORDER OF SIDE MENU CHANGE HERE
        sidemenuArray = [myProfile,walletStatement,myOrders,changePaymentOption,settings,more,logout]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.sideMenuViewController?.dismiss(animated: true, completion: nil)
        self.sideMenuViewController?.hideMenuViewController()
    }
    

}

extension SideMenuViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
//            let firstVC = storyboard?.instantiateViewController(withIdentifier: "HistoryViewController") as! HistoryViewController
//            self.navigationController?.pushViewController(firstVC, animated: true)
            break
        case 1:
            let secondVC = storyboard?.instantiateViewController(withIdentifier: "WalletStatementViewController") as! WalletStatementViewController
            self.navigationController?.pushViewController(secondVC, animated: true)
        case 2:
            let secondVC = storyboard?.instantiateViewController(withIdentifier: "MyOrdersViewController") as! MyOrdersViewController
            self.navigationController?.pushViewController(secondVC, animated: true)
            
        case 3:

            let newVC = self.storyboard?.instantiateViewController(withIdentifier: "RemittanceViewController") as! RemittanceViewController
            self.navigationController?.pushViewController(newVC, animated: true)
        case 4:
            let secondVC = storyboard?.instantiateViewController(withIdentifier: "RewardPointsViewController") as! RewardPointsViewController
            self.navigationController?.pushViewController(secondVC, animated: true)
        case 5:
            let secondVC = storyboard?.instantiateViewController(withIdentifier: "MoreViewController") as! MoreViewController
            self.navigationController?.pushViewController(secondVC, animated: true)
//        case 6:
//            if let secondVC = storyboard?.instantiateViewController(withIdentifier: "secondViewController") {
//                let contentViewController = UINavigationController(rootViewController: secondVC)
//                sideMenuViewController?.setContentViewController(contentViewController, animated: true)
//                sideMenuViewController?.hideMenuViewController()
//            }
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
