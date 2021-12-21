//
//  ProductListViewController.swift
//  Actorpay
//
//  Created by iMac on 07/12/21.
//

import UIKit

class ProductListViewController: UIViewController {

    //MARK: - Properties -
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mainView: UIView!
    
    var productArray = [1,2,3,4,5,6,7]
    
    //MARK: - Life Cycle Function -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        topCorner(bgView: mainView, maskToBounds: true)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    //MARK: - Selectors -
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        //Back Button Action
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Helper Function -
}

//MARK: - Extensions -

extension ProductListViewController: UITableViewDelegate, UITableViewDataSource {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
