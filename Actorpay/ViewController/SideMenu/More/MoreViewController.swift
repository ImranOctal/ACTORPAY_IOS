//
//  MoreViewController.swift
//  Actorpay
//
//  Created by iMac on 06/12/21.
//

import UIKit

class MoreViewController: UIViewController {

    @IBOutlet weak var mainView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topCorner(bgView: mainView, maskToBounds: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func aboutUsButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let newVC = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    
    @IBAction func contactUsButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let newVC = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    
    @IBAction func faqButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
//        let newVC = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
//        self.navigationController?.pushViewController(newVC, animated: true)
        let newVC = self.storyboard?.instantiateViewController(withIdentifier: "FAQViewController") as! FAQViewController
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    
    @IBAction func termsAndConditionButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let newVC = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    
    @IBAction func privacyPolicyButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let newVC = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    
    
}
