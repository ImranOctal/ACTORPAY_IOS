//
//  RewardPointsViewController.swift
//  Actorpay
//
//  Created by iMac on 06/12/21.
//

import UIKit

class RewardPointsViewController: UIViewController {

    //MARK: - Properties -
   
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Life Cycle Functions -
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
        self.navigationController?.navigationBar.isHidden = true
    }

    //MARK: - Selectors -
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
//        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func filterButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
    }
    
    //MARK: - Helper Functions -
    
}

//MARK: - Extension -

extension RewardPointsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RewardPointsTableViewCell", for: indexPath) as! RewardPointsTableViewCell
        return cell
    }
    
}
