//
//  WalletViewController.swift
//  Actorpay
//
//  Created by iMac on 03/12/21.
//

import UIKit

class WalletViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        selectedTabIndex = self.tabBarController?.selectedIndex ?? 0
    }
}
