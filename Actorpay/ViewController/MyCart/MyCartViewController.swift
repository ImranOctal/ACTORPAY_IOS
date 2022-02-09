//
//  MyCartViewController.swift
//  Actorpay
//
//  Created by iMac on 21/12/21.
//

import UIKit
import Alamofire

class MyCartViewController: UIViewController {

    //MARK: - Properties -
    
    @IBOutlet weak var tableView: UITableView! {
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    @IBOutlet weak var mainView: UIView! {
        didSet{
            topCorner(bgView: mainView, maskToBounds: true)
        }
    }
    
    @IBOutlet weak var priceView: UIView! {
        didSet{
            topCornerWithShadow(bgView: priceView, maskToBounds: false)
        }
    }
    @IBOutlet weak var emptyMessageView: UIView!
    @IBOutlet weak var subTotalLbl: UILabel!
    @IBOutlet weak var igstLbl: UILabel!
    @IBOutlet weak var totalLbl: UILabel!
    
    var cartList: CartList?
    
    //MARK: - Life Cycles -
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        cartItemList()
    }
    
    //MARK: - Selectors -
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        //back Button action
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func checkOutButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let newVC = self.storyboard?.instantiateViewController(withIdentifier: "CheckoutViewController") as! CheckoutViewController
        newVC.cartList = self.cartList
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    
    //MARK: - Helper Functions -
    
    // Set Cart Data
    func setCartData() {
        subTotalLbl.text = cartList?.totalTaxableValue?.doubleToStringWithComma()
        igstLbl.text = ((cartList?.totalCgst ?? 0.0) + (cartList?.totalSgst ?? 0.0)).doubleToStringWithComma()
        totalLbl.text = cartList?.totalPrice?.doubleToStringWithComma()
    }
    
}

//MARK: - Extensions -

//MARK:  Api Call
extension MyCartViewController {
    
    // Cart List Api
    func cartItemList(){
        let params: Parameters = [:]
        print(params)
        showLoading()
        APIHelper.getCartItemsList(parameters: params) { (success, response) in
            if !success {
                dissmissLoader()
                let message = response.message
                print(message)
                self.view.makeToast(message)
            }else {
                dissmissLoader()
                let data = response.response["data"]
                self.cartList = CartList.init(json: data)
                if self.cartList?.cartItemDTOList?.count == 0 {
                    self.priceView.isHidden = true
                    self.emptyMessageView.isHidden = false
                }else{
                    self.emptyMessageView.isHidden = true
                    self.priceView.isHidden = false
                }
                self.setCartData()
                self.tableView.reloadData()
            }
        }
    }
    
    // remove item from cart
    func removeCartItem(id: String) {
        showLoading()
        APIHelper.removeCartItem(id: id) { (success, response) in
            if !success {
                dissmissLoader()
                let message = response.message
                print(message)
                self.view.makeToast(message)
            }else {
                dissmissLoader()
                self.cartItemList()
            }
        }
    }
    
    // Update Cart Item
    func updateCartItem(productQty: Int, cartItemId: String) {
        let params: Parameters = [
            "cartItemId":cartItemId,
            "productQty":productQty
        ]
        showLoading()
        APIHelper.updateCartItem(params: params) { (success, response) in
            if !success {
                dissmissLoader()
                let message = response.message
                print(message)
                self.view.makeToast(message)
            }else {
                dissmissLoader()
                self.cartItemList()
            }
        }
    }
    
    
}

//MARK:  TableView SetUp
extension MyCartViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartList?.cartItemDTOList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCartTableViewCell", for: indexPath) as! MyCartTableViewCell
        cell.productTitleLabel.text = cartList?.cartItemDTOList?[indexPath.row].productName
        cell.productPriceLabel.text = "Price ₹\(cartList?.cartItemDTOList?[indexPath.row].productPrice?.doubleToStringWithComma() ?? "") (Including \(cartList?.cartItemDTOList?[indexPath.row].taxPercentage ?? 0)% gst)"
        cell.productImageView.sd_setImage(with: URL(string: cartList?.cartItemDTOList?[indexPath.row].image ?? ""),placeholderImage: UIImage(named: "NewLogo"), completed: nil)
        var count = self.cartList?.cartItemDTOList?[indexPath.row].productQty ?? 0
        cell.productQuntityLabel.text = "\(count)"
        let cartItemId = self.cartList?.cartItemDTOList?[indexPath.row].cartItemId ?? ""
        cell.addButtonHandler = {
            count += 1
            cell.productQuntityLabel.text = "\(count)"
            self.updateCartItem(productQty: count,cartItemId: cartItemId)
        }
        cell.minusButtonHandler = {
            if count == 1 {
                return
            }
            count -= 1
            cell.productQuntityLabel.text = "\(count)"
            self.updateCartItem(productQty: count, cartItemId: cartItemId)
        }
        
        cell.deleteButtonHandler = {
            let alert = UIAlertController(title: "Delete Item", message: "Are you sure you want to remove product?", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default) { (action) in
                self.removeCartItem(id: self.cartList?.cartItemDTOList?[indexPath.row].cartItemId ?? "")
            }
            let cancel = UIAlertAction(title: "Cancel", style: .default) { (action) in
                self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(cancel)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
       
        let clearView = UIView()
        clearView.backgroundColor = .clear // Whatever color you like
        cell.selectedBackgroundView = clearView
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
