//
//  SettingsViewController.swift
//  Actorpay
//
//  Created by iMac on 17/01/22.
//

import UIKit

class SettingsViewController: UIViewController {
    
    //MARK: - Properties -
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var switchButton: UISwitch!
    
    
    //MARK: - Life Cycles -

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        /*if let isNotificationEnabled = isNotificationEnabled {
            switchButton.isOn = isNotificationEnabled
        }*/
        topCorner(bgView: mainView, maskToBounds: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        refreshSwitch()
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    //MARK: - Selectors -
    
    // Menu Button Action
    @IBAction func menuButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.sideMenuViewController?.presentLeftMenuViewController()
    }
    
    // My Addresses Button Action
    @IBAction func myAddressesButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let newVC = self.storyboard?.instantiateViewController(withIdentifier: "ManageAddressViewController") as! ManageAddressViewController
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    
    // Change Password Button Action
    @IBAction func changePasswordButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let newVC = (self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordViewController") as? ChangePasswordViewController)!
        newVC.view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        self.definesPresentationContext = true
        self.providesPresentationContextTransitionStyle = true
        newVC.modalPresentationStyle = .overCurrentContext
        self.navigationController?.present(newVC, animated: true, completion: nil)
    }
    
    // Change Payment Option Button Action
    @IBAction func changePaymentOptionButtonAction (_ sender: UIButton) {
        self.view.endEditing(true)
        let newVC = self.storyboard?.instantiateViewController(withIdentifier: "RemittanceViewController") as! RemittanceViewController
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    
    // Notification Switch Action
    @IBAction func notificationButton(_ sender: UISwitch) {
        self.view.endEditing(true)
        guard let url = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    // Notification Switch Action
    @IBAction func notificationAction(_ sender: UISwitch){
        var msg = ""
        if pushEnabledAtOSLevel() {
            msg = "If you turn off notifications for this app, you may miss important alert and updates."
        } else {
            msg = "WARNING: Push Notifications are disabled. To enable visit: iPhone Settings > Notifications > Actor Pay."
        }
        let alertController = UIAlertController(title: "Settings", message: msg, preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
            if let appSettings = NSURL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.openURL(appSettings as URL)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            self.refreshSwitch()
        })
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - Helper Functions -
    
    @objc func willEnterForeground() {
        refreshSwitch()
    }
    
    func refreshSwitch(){
        if pushEnabledAtOSLevel(){
            switchButton.isOn = true
        } else {
            switchButton.isOn = false
        }
    }
    
    func pushEnabledAtOSLevel() -> Bool {
        guard let currentSettings = UIApplication.shared.currentUserNotificationSettings?.types else { return false }
        return currentSettings.rawValue != 0
    }

}

//MARK: - Extensions -

extension SettingsViewController {
    
}
