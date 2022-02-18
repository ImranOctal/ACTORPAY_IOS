//
//  ProductListViewController.swift
//  Actorpay
//
//  Created by iMac on 07/12/21.
//

import UIKit
import Alamofire
import SVPullToRefresh
import PopupDialog

class ProductListViewController: UIViewController {
    
    //MARK: - Properties -
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            searchTextField.delegate = self
        }
    }
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet {
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
        }
    }
    
    var product: ProductList?
    var productList: [Items] = []
    var cartList: CartList?
    var selctedCartIndex:[Int] = []
    var page = 0
    var totalCount = 10
    var buyNow = false
    var filterparm: Parameters?
    var selectedrow = Int()
    var categoryFilter : Parameters?
    var addToCartProductId : String?
    var addToCartProductPrice : Double?
    
    //MARK: - Life Cycle Function -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topCorner(bgView: mainView, maskToBounds: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getProductListAPI()
        self.navigationController?.navigationBar.isHidden = true
        tableView.addPullToRefresh {
            self.page = 0
            self.getProductListAPI(bodyParameter: self.categoryFilter)
        }
    }
    
    //MARK: - Selectors -
    
    // Back Button Action
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
  
    // Cart Button Action
    @IBAction func cartButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let newVC = self.storyboard?.instantiateViewController(withIdentifier: "MyCartViewController") as! MyCartViewController
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    
    // Sort Button Action
    @IBAction func sortButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let newVC = (self.storyboard?.instantiateViewController(withIdentifier: "FilterViewController") as! FilterViewController)
        newVC.filterparm = filterparm
        newVC.completion = { param in
            self.filterparm = param
            self.getProductListAPI()
        }
        newVC.view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        self.definesPresentationContext = true
        self.providesPresentationContextTransitionStyle = true
        newVC.modalPresentationStyle = .overCurrentContext
        self.navigationController?.present(newVC, animated: true, completion: nil)
    }
    
    //MARK: - Helper Function -
    
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
extension ProductListViewController {
    
    // Product List Api
    func getProductListAPI(parameter: Parameters? = nil, bodyParameter:Parameters? = nil) {
        var parameters = Parameters()
        
        if parameter == nil {
            if let parameter = filterparm {
                parameters = parameter
            }
            parameters["pageNo"] = page
            parameters["pageSize"] = 10
        } else{
            page = 0
            if let parameter = parameter {
                parameters = parameter
            }
            parameters["pageNo"] = page
            parameters["pageSize"] = 10
        }
        
        var bodyParam = Parameters()
        if bodyParameter == nil {
            bodyParam = [:]
        } else {
            if let bodyParameter = bodyParameter {
                bodyParam = bodyParameter
            }
        }
        
        print(parameters)
        showLoading()
        APIHelper.productListApi(urlParameters: parameters,bodyParameter: bodyParam) { (success, response) in
            self.tableView.pullToRefreshView?.stopAnimating()
            if !success {
                dissmissLoader()
                let message = response.message
                myApp.window?.rootViewController?.view.makeToast(message)
            }else {
                dissmissLoader()
                let data = response.response["data"]
                self.product = ProductList.init(json: data)
                if self.page == 0 {
                    self.productList = ProductList.init(json: data).items ?? []
                } else{
                    self.productList.append(contentsOf: ProductList.init(json: data).items ?? [])
                }
                self.totalCount = self.product?.totalItems ?? 0
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
                self.selctedCartIndex.removeAll()
                for (i, val) in (self.productList).enumerated() {
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

//MARK: Tableview Setup
extension ProductListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.productList.count == 0 {
            tableView.setEmptyMessage("No Data Found")
        }else{
            tableView.restore()
        }
        return self.productList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTableViewCell", for: indexPath) as! ProductTableViewCell
        let item = self.productList[indexPath.row]
        cell.item = item
        if self.selctedCartIndex.contains(indexPath.row) {
            cell.addToCartButton.setTitle("Go To Cart", for: .normal)
            cell.addToCartButtonHandler = {
                let newVC = self.storyboard?.instantiateViewController(withIdentifier: "MyCartViewController") as! MyCartViewController
                newVC.cartList = self.cartList
                self.navigationController?.pushViewController(newVC, animated: true)
            }
        } else {
            cell.addToCartButton.setTitle("Add To Cart", for: .normal)
            cell.addToCartButtonHandler = {
                if self.cartList?.merchantId != item.merchantId && self.cartList?.merchantId != nil {
                    self.replaceCartItemAler()
                    self.addToCartProductId = item.productId ?? ""
                    self.addToCartProductPrice = item.dealPrice ?? 0.0
                } else {
                    self.addToCartProductId = item.productId ?? ""
                    self.addToCartProductPrice = item.dealPrice ?? 0.0
                    self.addToCart()
                }
            }
        }
        cell.buyNowButtonHandler = {
            if (self.cartList?.cartItemDTOList ?? []).contains(where:{($0.productId  == item.productId )}) {
                let newVC = self.storyboard?.instantiateViewController(withIdentifier: "MyCartViewController") as! MyCartViewController
                self.navigationController?.pushViewController(newVC, animated: true)
            }
            if self.cartList?.merchantId != item.merchantId && self.cartList?.merchantId != nil {
                self.replaceCartItemAler()
                self.buyNow = true
                self.addToCartProductId = item.productId ?? ""
                self.addToCartProductPrice = item.dealPrice ?? 0.0
            } else {
                self.buyNow = true
                self.addToCartProductId = item.productId ?? ""
                self.addToCartProductPrice = item.dealPrice ?? 0.0
                self.addToCart()
            }
        }
        
        let clearView = UIView()
        clearView.backgroundColor = .clear // Whatever color you like
        cell.selectedBackgroundView = clearView
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = self.productList[indexPath.row]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
        vc.productId = item.productId ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

// MARK: ScrollView Setup
extension ProductListViewController: UIScrollViewDelegate{
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let _ = scrollView as? UITableView {
            let currentOffset = scrollView.contentOffset.y
            let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
            let totalRecords = self.productList.count
            // Change 10.0 to adjust the distance from bottom
            if maximumOffset - currentOffset <= 10.0 && /*totalRecords >= 10*/totalRecords < totalCount {
                if page < ((self.product?.totalPages ?? 0)-1) {
                    page += 1
                    self.getProductListAPI(bodyParameter: categoryFilter)
                }
            }
        }
    }
}

//MARK: - UI Text Field Delegate
extension ProductListViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        switch textField {
        case searchTextField:
            print("search")
            var filterParam = Parameters()
            if let parameter = filterparm {
                filterParam = parameter
            }
            filterParam["name"] = searchTextField.text ?? ""
            self.getProductListAPI(bodyParameter: filterParam)
        default:
            break
        }
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text == "" {
            self.getProductListAPI()
        }
    }
    
}

//MARK: Collection View Setup
extension ProductListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1 + (categoryList?.items?.count ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCategoryFilterCell", for: indexPath) as! ProductCategoryFilterCell
        if indexPath.row == 0 {
            cell.categoryName.text = "All"
        } else {
            cell.categoryName.text = categoryList?.items?[indexPath.row - 1].name
        }
        if indexPath.row == selectedrow {
            cell.categoryName.textColor = UIColor.white
            cell.categoryView.backgroundColor = UIColor.init(hexFromString: "2878B6")
        } else {
            cell.categoryName.textColor = UIColor.black
            cell.categoryView.backgroundColor = UIColor.init(hexFromString: "EEEEEF")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedrow == indexPath.row {
            return
        }
        let ind = IndexPath(row: selectedrow, section: 0)
        selectedrow = indexPath.row
        collectionView.reloadItems(at: [ind, indexPath])
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        if indexPath.row == 0 {
            getProductListAPI()
        } else {
            page = 0
            let params: Parameters = [
                "categoryName":"\(categoryList?.items?[indexPath.row - 1].name ?? "")"
            ]
            categoryFilter = params
            getProductListAPI(bodyParameter: categoryFilter)
        }
        
    }
    
}

//MARK: CustomAlert Delegate Methods
extension ProductListViewController: CustomAlertDelegate {
    
    func okButtonclick() {
        self.clearCartItemApi()
        self.dismiss(animated: true, completion: nil)
    }
    
    func cancelButtonClick() {
        self.dismiss(animated: true, completion: nil)
    }
}

