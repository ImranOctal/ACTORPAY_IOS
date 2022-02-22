//
//  ProductDetailsViewController.swift
//  Actorpay
//
//  Created by iMac on 06/12/21.
//

import UIKit
import SDWebImage
import Alamofire
import PopupDialog

class ProductDetailsViewController: UIViewController {
    
    //MARK: - Properties -
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.tableView.delegate = self
            self.tableView.dataSource = self
        }
    }
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableViewHeightConstaint: NSLayoutConstraint!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var actualPriceLabel: UILabel!
    @IBOutlet weak var dealPriceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var buyNowButton: UIButton!
    @IBOutlet weak var addToCartButton: UIButton!
    
    var productArray = [1,2,3,4,5,6,7]
    var item: Items?
    var productId = ""
    var isFavourite = false
    var addToCartProductId : String?
    var addToCartProductPrice : Double?
    var buyNow = false
    var cartList: CartList?
    
    //MARK: - Life Cycle Function -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        scrollView.delegate = self
        self.tableViewHeightConstaint.constant = (productArray.count == 0 ? 120.0 : CGFloat( 130 * productArray.count))
        self.getProductDetailsApi()
    }
    
    //MARK: - Selectors -
    
    // Back Button action
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    // Favourite Button Action
    @IBAction func favouriteButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        isFavourite = !isFavourite
        sender.setImage( UIImage(named: isFavourite ? "liked_small" : "like_small"), for: .normal)
    }
    
    // Buy Now Button action
    @IBAction func buyNowButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if (self.cartList?.cartItemDTOList ?? []).contains(where:{($0.productId  == item?.productId )}) {
            let newVC = self.storyboard?.instantiateViewController(withIdentifier: "MyCartViewController") as! MyCartViewController
            self.navigationController?.pushViewController(newVC, animated: true)
            return
        }
        if self.cartList?.merchantId != item?.merchantId && self.cartList?.merchantId != nil {
            self.replaceCartItemAler()
            self.buyNow = true
        } else {
            self.buyNow = true
            self.addToCart()
        }
    }
    
    // Add To Cart Button action
    @IBAction func addToCartButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if addToCartButton.titleLabel?.text == "Go To Cart" {
            let newVC = self.storyboard?.instantiateViewController(withIdentifier: "MyCartViewController") as! MyCartViewController
            newVC.cartList = self.cartList
            self.navigationController?.pushViewController(newVC, animated: true)
        } else {
            if self.cartList?.merchantId != item?.merchantId && self.cartList?.merchantId != nil {
                self.replaceCartItemAler()
            } else {
                self.addToCart()
            }
        }
    }
    
    //MARK:- Helper Functions -
    
    // Set Up Product Details Data
    func setupProductData(){
        if let item = self.item {
            let totalGst = (item.cgst ?? 0) + (item.sgst ?? 0)
            self.productImageView.sd_setImage(with: URL(string: item.image ?? ""), placeholderImage: UIImage(named: "NewLogo"), options: SDWebImageOptions.allowInvalidSSLCertificates, completed: nil)
            productTitleLabel.text = item.name ?? ""
            descriptionLabel.text = item.description ?? ""
            actualPriceLabel.text = ((item.actualPrice ?? 0)).doubleToStringWithComma()
            dealPriceLabel.text = (item.dealPrice ?? 0 + totalGst).doubleToStringWithComma()
        }
    }
    
    // Replace Cart Item Alert
    func replaceCartItemAler() {
        let customV = self.storyboard?.instantiateViewController(withIdentifier: "CustomAlertViewController") as! CustomAlertViewController
        let popup = PopupDialog(viewController: customV, buttonAlignment: .horizontal, transitionStyle: .bounceUp, tapGestureDismissal: true)
        customV.setUpCustomAlert(titleStr: "Replace Cart Item", descriptionStr: "Your cart contains products from different Merchant, Do you want to discard the selection and add this product?", isShowCancelBtn: false)
        customV.customAlertDelegate = self
        self.present(popup, animated: true, completion: nil)
    }
}

//MARK: - Extensions -

//MARK: Api Call
extension ProductDetailsViewController {
    
    // Product Details Api
    func getProductDetailsApi() {
        showLoading()
        APIHelper.getProductDetails(id: productId) { [self] (success, response) in
            if !success {
                dissmissLoader()
                let message = response.message
                print(message)
                myApp.window?.rootViewController?.view.makeToast(message)
            } else {
                dissmissLoader()
                let message = response.message
                print(message)
//                myApp.window?.rootViewController?.view.makeToast(message)
                let data = response.response["data"]
                self.item = Items.init(json: data)
                self.addToCartProductId = self.item?.productId
                self.addToCartProductPrice = self.item?.dealPrice
                self.setupProductData()
                self.cartItemList()
                self.tableView.reloadData()
            }
        }
    }
    
    // Add to Cart Api
    func addToCart() {
        let params: Parameters = [
            "productId":"\(addToCartProductId ?? "")",
            "productPrice":addToCartProductPrice ?? 0.0,
            "productQty":1
        ]
        print(params)
        showLoading()
        APIHelper.addToCartProduct(params: params) { (success, response) in
            if !success {
                dissmissLoader()
                let message = response.message
                myApp.window?.rootViewController?.view.makeToast(message)
                print(message)
            }else {
                dissmissLoader()
                let message = response.message
                //                myApp.window?.rootViewController?.view.makeToast(message)
                print(message)
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
                myApp.window?.rootViewController?.view.makeToast(message)
                print(message)
            }else {
                dissmissLoader()
                let data = response.response["data"]
                self.cartList = CartList.init(json: data)
                for (_, value) in (self.cartList?.cartItemDTOList ?? []).enumerated() {
                    if value.productId == self.item?.productId {
                        self.addToCartButton.setTitle("Go To Cart", for: .normal)
                    }
                }
            }
        }
    }
    
    // Clear Cart Item Api
    func clearCartItemApi() {
        showLoading()
        APIHelper.clearCartItemApi(urlParameters: [:], bodyParameter: [:]) { (success, response) in
            if !success {
                dissmissLoader()
                let message = response.message
                self.view.makeToast(message)
            } else {
                dissmissLoader()
                let message = response.message
                print(message)
                //                self.view.makeToast(message)
                self.cartItemList()
                self.addToCart()
            }
        }
    }
}

//MARK: Table View SetUp
extension ProductDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTableViewCell", for: indexPath) as! ProductTableViewCell        
        cell.iconImage.sd_setImage(with: URL(string: item?.image ?? ""), placeholderImage: UIImage(named: "NewLogo"), options: SDWebImageOptions.allowInvalidSSLCertificates, completed: nil)
        
        return cell
    }
    
}

//MARK: Scroll View Delegate Methods

extension ProductDetailsViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: scrollView.contentOffset, size: scrollView.bounds.size)
        if (visibleRect.minY < 100) {
            headerView.isHidden = false
        } else{
            headerView.isHidden = true
        }
    }
    
}

//MARK: CustomAlert Delegate Methods
extension ProductDetailsViewController: CustomAlertDelegate {
    
    func okButtonclick() {
        self.clearCartItemApi()
        self.dismiss(animated: true, completion: nil)
    }
    
    func cancelButtonClick() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
