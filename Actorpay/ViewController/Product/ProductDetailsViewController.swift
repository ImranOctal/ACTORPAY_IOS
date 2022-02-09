//
//  ProductDetailsViewController.swift
//  Actorpay
//
//  Created by iMac on 06/12/21.
//

import UIKit
import SDWebImage

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
    
    var productArray = [1,2,3,4,5,6,7]
    var item: Items?
    var productId = ""
    var isFavourite = false
    
    //MARK: - Life Cycle Function -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        scrollView.delegate = self
        self.tableViewHeightConstaint.constant = (productArray.count == 0 ? 120.0 : CGFloat( 120 * productArray.count))
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
       print("Buy Now Button Tapped")
    }
    
    // Add To Cart Button action
    @IBAction func addToCartButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        print("Add To Cart Button Tapped")
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
}

//MARK: - Extensions -

//MARK: Api Call
extension ProductDetailsViewController {
    
    // Product Details Api
    func getProductDetailsApi(){
        showLoading()
        APIHelper.getProductDetails(id: productId) { (success, response) in
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
                self.setupProductData()
                self.tableView.reloadData()
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

