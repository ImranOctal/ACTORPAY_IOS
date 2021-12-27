//
//  CheckoutViewController.swift
//  Actorpay
//
//  Created by iMac on 21/12/21.
//

import UIKit

class CheckoutViewController: UIViewController {
    
    //MARK: - Properties -
    @IBOutlet weak var addressTableView: UITableView! {
        didSet{
            addressTableView.delegate = self
            addressTableView.dataSource = self
        }
    }
    
    @IBOutlet weak var addressTableViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var paymentMethodTableView: UITableView! {
        didSet{
            paymentMethodTableView.delegate = self
            paymentMethodTableView.dataSource = self
        }
    }
    
    @IBOutlet weak var paymentMethodTableViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var mainView: UIView! {
        didSet{
            topCorner(bgView: mainView, maskToBounds: true)
        }
    }
    
    var addressArray:[Int] = [1,2,3]
    var cardArray:[Int] = [1,2,3,5]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewHeightManage()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        //back Button action
        self.navigationController?.popViewController(animated: true)
    }

    //MARK:- Helper Functions -
    func tableViewHeightManage() {
        //tableView Height Manage
        addressTableViewHeightConstraint.constant = (addressArray.count == 0 ? 100.0 : CGFloat( 100 * addressArray.count))
        paymentMethodTableViewHeightConstraint.constant = (cardArray.count == 0 ? 65.0 : CGFloat( 65 * cardArray.count))
    }

    
}

//MARK: - Extensions -

extension CheckoutViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView == addressTableView ? 3 : 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == addressTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "addressTableViewCell", for: indexPath) as! addressTableViewCell
            
            let clearView = UIView()
            clearView.backgroundColor = .clear // Whatever color you like
            cell.selectedBackgroundView = clearView
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cardTableViewCell", for: indexPath) as! cardTableViewCell
            
            let clearView = UIView()
            clearView.backgroundColor = .clear // Whatever color you like
            cell.selectedBackgroundView = clearView
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
