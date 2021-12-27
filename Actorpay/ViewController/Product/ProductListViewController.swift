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
    var itemsList:[Items] = []
    var cartList: CartList?
    var page = 0
    var totalCount = 10
    
    //MARK: - Life Cycle Function -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topCorner(bgView: mainView, maskToBounds: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.cartItemList()
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
    
    //MARK: - Helper Function -
    
    // Product List Api
    func getProductListAPI(){
        let params: Parameters = [
            "pageNo":page,
            "pageSize":10
        ]
        print(params)
        showLoading()
        APIHelper.getProductList(parameters: params) { (success, response) in
            if !success {
                dissmissLoader()
                let message = response.message
                myApp.window?.rootViewController?.view.makeToast(message)
            }else {
                dissmissLoader()
                let data = response.response["data"]
                self.productList = ProductList.init(json: data)
                self.totalCount = self.productList?.totalItems ?? 0
                for item in self.productList?.items ?? [] {
                    self.itemsList.append(item)
                }
                let message = response.message
                myApp.window?.rootViewController?.view.makeToast(message)
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
                myApp.window?.rootViewController?.view.makeToast(message)
            }else {
                dissmissLoader()
                let message = response.message
                myApp.window?.rootViewController?.view.makeToast(message)
                self.tableView.reloadData()
            }
        }
    }
    
    // Cart List Api
    func cartItemList(){
        let params: Parameters = [:]
        print(params)
        showLoading()
        APIHelper.getProductList(parameters: params) { (success, response) in
            if !success {
                dissmissLoader()
                let message = response.message
                myApp.window?.rootViewController?.view.makeToast(message)
            }else {
                dissmissLoader()
                let data = response.response["data"]
                self.cartList = CartList.init(json: data)
                self.tableView.reloadData()
            }
        }
    }
}

//MARK: - Extensions -

//MARK: Tableview Setup

extension ProductListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTableViewCell", for: indexPath) as! ProductTableViewCell
        let item = self.itemsList[indexPath.row]
        cell.item = item
        if cell.item?.productId == cartList?.cartItemDTOList?[indexPath.row].productId
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
                self.addToCart(productId: item.productId ?? "", productPrice: item.dealPrice ?? 0.0)
                self.cartItemList()
            }
        }
        cell.likeButtonHandler = {
            cell.likeButton.isSelected = !cell.likeButton.isSelected
        }
        
        let clearView = UIView()
        clearView.backgroundColor = .clear // Whatever color you like
        cell.selectedBackgroundView = clearView
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = self.itemsList[indexPath.row]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
        vc.productId = item.productId ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

// MARK: ScrollView Setup
extension ProductListViewController: UIScrollViewDelegate{
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let totalRecords = self.itemsList.count
        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 10.0 && totalRecords < totalCount {
            page += 1
            self.getProductListAPI()
        }
    }
    
}
