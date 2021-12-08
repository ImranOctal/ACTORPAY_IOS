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
    
    var productArray = [1,2,3,4,5,6,7]
    
    //MARK: - Life Cycle Function -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        scrollView.delegate = self
        tableViewHeightManage()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    //MARK: - Selectors -
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        //back Button action
        self.navigationController?.popViewController(animated: true)
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
    
}

//MARK: - Extensions -

extension ProductDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTableViewCell", for: indexPath) as! ProductTableViewCell
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

