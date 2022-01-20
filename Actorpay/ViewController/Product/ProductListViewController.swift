//
//  ProductListViewController.swift
//  Actorpay
//
//  Created by iMac on 07/12/21.
//

import UIKit
import Alamofire

class ProductListViewController: UIViewController {
    
    //MARK: - Properties -
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    @IBOutlet weak var mainView: UIView!
    
    var productList: ProductList?
    var cartList: CartList?
    var selctedCartIndex:[Int] = []
    var page = 0
    var totalCount = 10
    var buyNow = false
    
    //MARK: - Life Cycle Function -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topCorner(bgView: mainView, maskToBounds: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getProductListAPI()
        self.navigationController?.navigationBar.isHidden = true
    }
    //MARK: - Selectors -
    
    // Back Button Action
    @IBAction func backButtonAction(_ sender: UIButton) {
        //Back Button Action
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    // Cart Button Action
    @IBAction func cartButtonAction(_ sender: UIButton) {
        let newVC = self.storyboard?.instantiateViewController(withIdentifier: "MyCartViewController") as! MyCartViewController
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    
    @IBAction func sortButtonAction(_ sender: UIButton) {
        let newVC = (self.storyboard?.instantiateViewController(withIdentifier: "FilterViewController") as! FilterViewController)
        newVC.view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        self.definesPresentationContext = true
        self.providesPresentationContextTransitionStyle = true
        newVC.modalPresentationStyle = .overCurrentContext
        self.navigationController?.present(newVC, animated: true, completion: nil)
    }
    
    //MARK: - Helper Function -
    
    // Product List Api
    func getProductListAPI(){
        let params: Parameters = [
            "pageNo":page,
            "pageSize":10
        ]
        print(params)
        showLoading()
        APIHelper.productListApi(params: [:]) { (success, response) in
            if !success {
                dissmissLoader()
                let message = response.message
                myApp.window?.rootViewController?.view.makeToast(message)
            }else {
                dissmissLoader()
                let data = response.response["data"]
                self.productList = ProductList.init(json: data)
                self.totalCount = self.productList?.totalItems ?? 0
//                let message = response.message
//                myApp.window?.rootViewController?.view.makeToast(message)
                self.cartItemList()
                self.tableView.reloadData()
            }
        }
    }
    // Add to Cart Api
    func addToCart(productId: String, productPrice: Float) {
        let params: Parameters = [
            "productId":"\(productId)",
            "productPrice":productPrice,
            "productQty":1
        ]
        print(params)
        showLoading()
        APIHelper.addToCartProduct(params: params) { (success, response) in
            if !success {
                dissmissLoader()
                let message = response.message
//                myApp.window?.rootViewController?.view.makeToast(message)
            }else {
                dissmissLoader()
                let message = response.message
//                myApp.window?.rootViewController?.view.makeToast(message)
                self.cartItemList()
                self.tableView.reloadData()
                if self.buyNow == true {
                    self.buyNow = false
                    let newVC = self.storyboard?.instantiateViewController(withIdentifier: "MyCartViewController") as! MyCartViewController
                    self.navigationController?.pushViewController(newVC, animated: true)
                }
            }
        }
    }
    
    // Cart List Api
    func cartItemList(){
        let params: Parameters = [:]
        print(params)
        showLoading()
        APIHelper.getCartItemsList(parameters: params) { (success, response) in
            if !success {
                dissmissLoader()
                let message = response.message
//                myApp.window?.rootViewController?.view.makeToast(message)
            }else {
                dissmissLoader()
                let data = response.response["data"]
                self.cartList = CartList.init(json: data)
                
                for (i, val) in (self.productList?.items ?? []).enumerated() {
                    for (_, value) in (self.cartList?.cartItemDTOList ?? []).enumerated() {
                        if val.productId == value.productId {
                            self.selctedCartIndex.append(i)
                        }
                    }
                }
                self.tableView.reloadData()
            }
        }
    }
}

//MARK: - Extensions -

//MARK: Tableview Setup

extension ProductListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.productList?.items?.count == 0 {
            tableView.setEmptyMessage("No Found Data")
        }else{
            tableView.restore()
        }
        return self.productList?.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTableViewCell", for: indexPath) as! ProductTableViewCell
        let item = self.productList?.items?[indexPath.row]
        cell.item = item
        if self.selctedCartIndex.contains(indexPath.row)
        {
            cell.addToCartButton.setTitle("Go To Cart", for: .normal)
            cell.addToCartButtonHandler = {
                let newVC = self.storyboard?.instantiateViewController(withIdentifier: "MyCartViewController") as! MyCartViewController
                newVC.cartList = self.cartList
                self.navigationController?.pushViewController(newVC, animated: true)
            }
        } else {
            cell.addToCartButton.setTitle("Add To Cart", for: .normal)
            cell.addToCartButtonHandler = {
                self.addToCart(productId: item?.productId ?? "", productPrice: item?.dealPrice ?? 0.0)
            }
        }
        cell.likeButtonHandler = {
            cell.likeButton.isSelected = !cell.likeButton.isSelected
        }
        
        cell.buyNowButtonHandler = {
            self.buyNow = true
            self.addToCart(productId: item?.productId ?? "", productPrice: item?.dealPrice ?? 0.0)
        }
        
        let clearView = UIView()
        clearView.backgroundColor = .clear // Whatever color you like
        cell.selectedBackgroundView = clearView
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = self.productList?.items?[indexPath.row]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
        vc.productId = item?.productId ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

// MARK: ScrollView Setup
extension ProductListViewController: UIScrollViewDelegate{
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let totalRecords = self.productList?.items?.count ?? 0
        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 10.0 && totalRecords < totalCount {
            page += 1
            self.getProductListAPI()
        }
    }
    
}
