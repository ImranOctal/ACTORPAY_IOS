//
//  PaymentSuccessAndFailViewController.swift
//  Actorpay
//
//  Created by iMac on 09/02/22.
//

import UIKit

class PaymentSuccessAndFailViewController: UIViewController {
    
    //MARK: - Properties -
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    var isSuccess = false

    //MARK: - Life Cycles -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        topCorner(bgView: bgView, maskToBounds: true)
        self.setUpUI()
    }
    
    //MARK: - Selectors -
    
    // Back Button Action
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Helper Functions -
    
    // SetUp UI
    func setUpUI() {
        if isSuccess {
            self.imgView.image = UIImage(named: "tick")
            self.descLabel.isHidden = false
            self.titleLabel.text = "Payment Succeed!"
        } else {
            self.imgView.image = UIImage(named: "exclamation-mark-in-a-circle")
            self.imgView.tintColor = UIColor.red
            self.descLabel.isHidden = true
            self.titleLabel.text = "Payment Failed"
        }
    }

}
