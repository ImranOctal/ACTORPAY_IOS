//
//  PaymentSucceedViewController.swift
//  Actorpay
//
//  Created by iMac on 03/12/21.
//

import UIKit

class PaymentSucceedViewController: UIViewController {
    
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @objc func timerAction() {
        timer.invalidate()
        self.navigationController?.popViewController(animated: true)
    }
}
