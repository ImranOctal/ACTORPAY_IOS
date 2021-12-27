//
//  MyOrdersViewController.swift
//  Actorpay
//
//  Created by iMac on 06/12/21.
//

import UIKit

class MyOrdersViewController: UIViewController {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var myOrders: [OrderDetails] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topCorner(bgView: mainView, maskToBounds: true)
//        tableView.register(UINib(nibName: "MyOrdersTableViewCell", bundle: nil), forCellReuseIdentifier: "MyOrdersTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getProductListAPI()
        self.navigationController?.navigationBar.isHidden = true
    }

    @IBAction func backButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func filterButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
    }
    
    func getProductListAPI(){
        showLoading()
        APIHelper.getAllOrders() { (success, response) in
            if !success {
                dissmissLoader()
                let message = response.message
                myApp.window?.rootViewController?.view.makeToast(message)
            }else {
                dissmissLoader()
                let data = response.response["data"]
                self.myOrders.append(OrderDetails(json: data)) 
                let message = response.message
                myApp.window?.rootViewController?.view.makeToast(message)
                self.tableView.reloadData()
            }
        }
    }
    
}

extension MyOrdersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyOrdersTableViewCell", for: indexPath) as! MyOrdersTableViewCell
        return cell
    }
    
}
