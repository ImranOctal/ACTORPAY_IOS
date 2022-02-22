//
//  ReferAndEarnViewController.swift
//  Actorpay
//
//  Created by iMac on 21/02/22.
//

import UIKit

class ReferAndEarnViewController: UIViewController {
    
    //MARK: - Properties -
    
    @IBOutlet weak var bgView: UIView!
    
    //MARK: - Life Cycles -

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        topCorner(bgView: bgView, maskToBounds: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: - Selectors -
    
    // SideMenu Button Action
    @IBAction func menuButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.sideMenuViewController?.presentLeftMenuViewController()
    }
    
    // Share Now Button Action
    @IBAction func shareNowButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
    }

}
