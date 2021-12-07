//
//  HistoryViewController.swift
//  Actorpay
//
//  Created by iMac on 02/12/21.
//

import UIKit

class HistoryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        selectedTabIndex = self.tabBarController?.selectedIndex ?? 0
    }
    
}
