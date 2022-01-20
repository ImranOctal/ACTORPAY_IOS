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
    
    //MARK: - Life Cycles -

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        topCorner(bgView: mainView, maskToBounds: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: - Selectors -
    
    // Menu Button Action
    @IBAction func menuButtonAction(_ sender: UIButton) {
        self.sideMenuViewController?.presentLeftMenuViewController()
    }
    
    // My Addresses Button Action
    @IBAction func myAddressesButtonAction(_ sender: UIButton) {
        let newVC = self.storyboard?.instantiateViewController(withIdentifier: "ManageAddressViewController") as! ManageAddressViewController
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    
    // Change Password Button Action
    @IBAction func changePasswordButtonAction(_ sender: UIButton) {
        let newVC = (self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordViewController") as? ChangePasswordViewController)!
        newVC.view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        self.definesPresentationContext = true
        self.providesPresentationContextTransitionStyle = true
        newVC.modalPresentationStyle = .overCurrentContext
        self.navigationController?.present(newVC, animated: true, completion: nil)
    }
    
    // Change Payment Option Button Action
    @IBAction func changePaymentOptionButtonAction (_ sender: UIButton) {
        let newVC = self.storyboard?.instantiateViewController(withIdentifier: "RemittanceViewController") as! RemittanceViewController
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    
    //MARK: - Helper Functions -

}

//MARK: - Extensions -

extension SettingsViewController {
    
}
