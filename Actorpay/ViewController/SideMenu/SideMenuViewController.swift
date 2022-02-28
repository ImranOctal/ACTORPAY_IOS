//
//  SideMenuViewController.swift
//  Actorpay
//
//  Created by iMac on 02/12/21.
//

import UIKit
import AKSideMenu
import PopupDialog

final class SideMenuViewController: UIViewController {
    
    //MARK: - Properties -
        
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(UINib(nibName: "SideMenuTableViewCell", bundle: nil), forCellReuseIdentifier: "SideMenuTableViewCell")
         }
    }
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var walletBalanceLbl: UILabel!
    
    var sidemenuArray = [typeAliasStringDictionary]()
    var selectedObject = typeAliasStringDictionary()

    // MARK: - Life Cycle Function -

    override public func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: Create Data Dic for Side menu
        let home: typeAliasStringDictionary = [VAL_TITLE :"Home", VAL_IMAGE : "home"]
        let myOrders: typeAliasStringDictionary = [VAL_TITLE :"My Orders", VAL_IMAGE : "my_orders"]
        let walletStatement: typeAliasStringDictionary = [VAL_TITLE :"Wallet Statement", VAL_IMAGE : "wallet_statement"]
        let rewardsPoints: typeAliasStringDictionary = [VAL_TITLE :"My Loyalty/Rewards Points", VAL_IMAGE : "my_profile"]
        let referral: typeAliasStringDictionary = [VAL_TITLE :"Referral", VAL_IMAGE : "refferal"]
        let dispute: typeAliasStringDictionary = [VAL_TITLE :"Dispute", VAL_IMAGE : "cancel_dispute"]
        let promo_offers: typeAliasStringDictionary = [VAL_TITLE :"Promo & Offers", VAL_IMAGE : "discount"]
        let my_profile: typeAliasStringDictionary = [VAL_TITLE :"My Profile", VAL_IMAGE : "user"]
        let settings: typeAliasStringDictionary = [VAL_TITLE :"Settings", VAL_IMAGE : "settings"]
        let more: typeAliasStringDictionary = [VAL_TITLE :"More", VAL_IMAGE : "more"]
        
        //TODO: CHANGE ORDER OF SIDE MENU CHANGE HERE
        sidemenuArray = [
            home,
            myOrders,
            walletStatement,
            rewardsPoints,
            referral,
            dispute,
            promo_offers,
            my_profile,
            settings,
            more
        ]
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name("setProfileData"), object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(self.setProfileData),name:Notification.Name("setProfileData"), object: nil)
        self.setProfileData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: - Selectors -
    
    @IBAction func logOutButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let customV = self.storyboard?.instantiateViewController(withIdentifier: "CustomAlertViewController") as! CustomAlertViewController
        let popup = PopupDialog(viewController: customV, buttonAlignment: .horizontal, transitionStyle: .bounceUp, tapGestureDismissal: true)
        customV.setUpCustomAlert(titleStr: "Logout", descriptionStr: "Are you sure you want to Logout?", isShowCancelBtn: false)
        customV.customAlertDelegate = self
        self.present(popup, animated: true, completion: nil)
    }
    
    //MARK: - Helper Functions -
    
    // Set Profile Data
    @objc func setProfileData() {
//        userImageView.sd_setImage(with: URL(string: user?.profilePicture ?? ""), placeholderImage: UIImage(named: "profile"), options: SDWebImageOptions.allowInvalidSSLCertificates, completed: nil)
        userImageView.image = UIImage(named: "profile")
        userNameLabel.text = (user?.firstName ?? "") + (user?.lastName ?? "")
        walletBalanceLbl.text = "₹ \(walletData?.amount ?? 0.0)"
    }
}

//MARK: - Extensions -

//MARK: TableView Delegate Methods
extension SideMenuViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.sideMenuViewController?.dismiss(animated: true, completion: nil)
        self.sideMenuViewController?.hideMenuViewController()
        switch indexPath.row {
        case 0:
            // Home
            let newVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeNav") as! UINavigationController
            myApp.window?.rootViewController = newVC
        case 1:
            // My Orders
            if let myOrderVC = storyboard?.instantiateViewController(withIdentifier: "MyOrdersViewController") {
                let contentViewController = UINavigationController(rootViewController: myOrderVC)
                sideMenuViewController?.setContentViewController(contentViewController, animated: true)
                sideMenuViewController?.hideMenuViewController()
            }
        case 2:
            // Wallet Statement
            isWalletView = true
            let newVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeNav") as! UINavigationController
            myApp.window?.rootViewController = newVC
        
        case 3:
            // My Loyalty/Reward Points
            if let rewardVC = storyboard?.instantiateViewController(withIdentifier: "RewardPointsViewController") {
                let contentViewController = UINavigationController(rootViewController: rewardVC)
                sideMenuViewController?.setContentViewController(contentViewController, animated: true)
                sideMenuViewController?.hideMenuViewController()
            }
        case 4:
            //Referral
            if let myReferVC = storyboard?.instantiateViewController(withIdentifier: "ReferAndEarnViewController") {
                let contentViewController = UINavigationController(rootViewController: myReferVC)
                sideMenuViewController?.setContentViewController(contentViewController, animated: true)
                sideMenuViewController?.hideMenuViewController()
            }
        case 5:
            // Dispute
            if let disputeVC = storyboard?.instantiateViewController(withIdentifier: "DisputesViewController") {
                let contentViewController = UINavigationController(rootViewController: disputeVC)
                sideMenuViewController?.setContentViewController(contentViewController, animated: true)
                sideMenuViewController?.hideMenuViewController()
            }
        case 6:
            //Promo and Offers
            self.view.endEditing(true)
            if let offerVC = storyboard?.instantiateViewController(withIdentifier: "OfferViewController") {
                let contentViewController = UINavigationController(rootViewController: offerVC)
                sideMenuViewController?.setContentViewController(contentViewController, animated: true)
                sideMenuViewController?.hideMenuViewController()
            }
        case 7:
            //My Profile
            isProfileView = true
            let newVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeNav") as! UINavigationController
            myApp.window?.rootViewController = newVC
        case 8:
            //Settings
            if let settingVC = storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") {
                let contentViewController = UINavigationController(rootViewController: settingVC)
                sideMenuViewController?.setContentViewController(contentViewController, animated: true)
                sideMenuViewController?.hideMenuViewController()
            }
        case 9:
            // More
            if let moreVC = storyboard?.instantiateViewController(withIdentifier: "MoreViewController") {
                let contentViewController = UINavigationController(rootViewController: moreVC)
                sideMenuViewController?.setContentViewController(contentViewController, animated: true)
                sideMenuViewController?.hideMenuViewController()
            }
        default:
            break
        }
    }
}

//MARK: TableView DataSource Methods
extension SideMenuViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
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
        return cell        
    }
}

//MARK: CustomAlert Delegate Methods
extension SideMenuViewController: CustomAlertDelegate {
    
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
