//
//  ProductDetailsViewController.swift
//  Actorpay
//
//  Created by iMac on 06/12/21.
//

import UIKit

class ProductDetailsViewController: UIViewController {
    
    //MARK: - Properties -
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableViewHeightConstaint: NSLayoutConstraint!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
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
        topConstraint.constant = UIDevice.current.hasNotch ? -47 : -20
        tableView.delegate = self
        tableView.dataSource = self
        scrollView.delegate = self
        tableViewHeightManage()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getProductListAPI()
        self.navigationController?.navigationBar.isHidden = true
    }
    //MARK: - Selectors -
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        //back Button action
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func favouriteButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        isFavourite = !isFavourite
        sender.setImage( UIImage(named: isFavourite ? "liked_small" : "like_small"), for: .normal)
    }
    
    @IBAction func buyNowButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        //Buy Now Button action
    }
    
    @IBAction func addToCartButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        //Add To Cart Button action
        
    }
    
    //MARK:- Helper Functions -
    func tableViewHeightManage() {
        //tableView Height Manage
        tableViewHeightConstaint.constant = (productArray.count == 0 ? 120.0 : CGFloat( 120 * productArray.count))
    }
    
    func getProductListAPI(){
        showLoading()
        APIHelper.getProductDetails(id: productId) { (success, response) in
            if !success {
                dissmissLoader()
                let message = response.message
                myApp.window?.rootViewController?.view.makeToast(message)
            }else {
                dissmissLoader()
                let data = response.response["data"]
                self.item = Items.init(json: data)
                let message = response.message
                self.setupProductData()
                myApp.window?.rootViewController?.view.makeToast(message)
                self.tableView.reloadData()
            }
        }
    }
    
    func setupProductData(){
        if let item = self.item {
            if let url = URL(string: item.image ?? "") {
                productImageView.sd_setImage(with: url, completed: nil)
            }
            productTitleLabel.text = item.name ?? ""
            descriptionLabel.text = item.description ?? ""
            actualPriceLabel.text = "\(item.actualPrice ?? 0)"
            dealPriceLabel.text = "\(item.dealPrice ?? 0)"            
        }
        
    }
}

//MARK: - Extensions -

extension ProductDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTableViewCell", for: indexPath) as! ProductTableViewCell
        
        
        cell.likeButtonHandler = {
            cell.likeButton.isSelected = !cell.likeButton.isSelected
        }
        
        return cell
    }
    
}

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

