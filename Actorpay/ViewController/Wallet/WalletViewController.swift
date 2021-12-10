//
//  WalletViewController.swift
//  Actorpay
//
//  Created by iMac on 03/12/21.
//

import UIKit

class WalletViewController: UIViewController {

    //MARK: - Properties -
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstaint: NSLayoutConstraint!
    
    var productArray = [1,2,3,4,5,6,7]
    
    //MARK: - Life Cycle Function -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topCorner(bgView: mainView, maskToBounds: true)
        tableView.delegate = self
        tableView.dataSource = self
        tableViewHeightManage()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        selectedTabIndex = self.tabBarController?.selectedIndex ?? 0
    }
    
    //MARK: - Selectors -
    
    //MARK:- Helper Functions -
    func tableViewHeightManage() {
        //tableView Height Manage
        tableViewHeightConstaint.constant = (productArray.count == 0 ? 125.0 : CGFloat( 120 * productArray.count))
    }
}

//MARK: - Extensions -

extension WalletViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WalletStatementTableViewCell", for: indexPath) as! WalletStatementTableViewCell
        return cell
    }    
}
