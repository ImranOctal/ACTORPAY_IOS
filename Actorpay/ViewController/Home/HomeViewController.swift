//
//  HomeViewController.swift
//  Actorpay
//
//  Created by iMac on 02/12/21.
//

import UIKit
import AKSideMenu
//import SwiftQRScanner

class HomeViewController: UIViewController {

    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var transactionView: UIView!
    @IBOutlet weak var transactionTableView: UITableView!
    
    var category:[Category] = [
        Category(title: "Add Money", icon: UIImage(named: "add_money")),
        Category(title: "Send Money", icon: UIImage(named: "send_money")),
        Category(title: "Mobile & DTH", icon: UIImage(named: "smartphone")),
        Category(title: "Utility Bill", icon: UIImage(named: "bill")),
        Category(title: "Add Money", icon: UIImage(named: "add_money")),
        Category(title: "Send Money", icon: UIImage(named: "send_money")),
        Category(title: "Mobile & DTH", icon: UIImage(named: "smartphone")),
        Category(title: "Utility Bill", icon: UIImage(named: "bill"))
        
    ]
    let contactHeaderHeight: CGFloat = 32
    var transactionArray:[Int] = [1,2,3]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topCorner(bgView: transactionView, maskToBounds: true)
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        transactionTableView.delegate = self
        transactionTableView.dataSource = self
        transactionTableView.register(UINib(nibName: "TransactionTableViewCell", bundle: nil), forCellReuseIdentifier: "TransactionTableViewCell")
        transactionTableView.estimatedRowHeight = 70
        transactionTableView.rowHeight = UITableView.automaticDimension
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        selectedTabIndex = self.tabBarController?.selectedIndex ?? 0
    }

    @IBAction func menuButtonAction(_ sender: UIButton){
        self.view.endEditing(true)
        self.sideMenuViewController?.presentLeftMenuViewController()
    }
    
    @IBAction func notificationButtonAction(_ sender: UIButton){
        self.view.endEditing(true)
//        let newVC = self.storyboard?.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
//        self.navigationController?.pushViewController(newVC, animated: true)
        let newVC = self.storyboard?.instantiateViewController(withIdentifier: "RemittanceViewController") as! RemittanceViewController
        self.navigationController?.pushViewController(newVC, animated: true)
    }

}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return category.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
        cell.iconImageView.image = category[indexPath.row].icon
        cell.titleLabel.text = category[indexPath.row].title
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddMoneyViewController") as! AddMoneyViewController
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTableViewCell", for: indexPath) as! TransactionTableViewCell
        if indexPath.row == 0 {
            topCorners(bgView: cell.mainView, cornerRadius: 15, maskToBounds: true)
            cell.sepratorView.isHidden = false
        }else if ((indexPath.row) == (transactionArray.count-1)){
            bottomCorner(bgView: cell.mainView, cornerRadius: 15, maskToBounds: true)
            cell.sepratorView.isHidden = true
        }else{
            topCorners(bgView: cell.mainView, cornerRadius: 0, maskToBounds: true)
            bottomCorner(bgView: cell.mainView, cornerRadius: 0, maskToBounds: true)
            cell.sepratorView.isHidden = false
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50))
        let label = UILabel(frame: CGRect(x: 20, y: -5, width: tableView.frame.size.width, height: 30))
        switch section {
        case 0:
            label.text = "Today Transactions"
        case 1:
            label.text = "Yesterday Transactions"
        default:
            label.text = ""
        }
//        label.font = UIFont.init(name: "Poppins-Medium", size: 10)
        label.font = .systemFont(ofSize: 12)

        label.textColor = UIColor.init(hexFromString: "#8C8C8C")
        view.backgroundColor = .white
        self.view.addSubview(view)
        view.addSubview(label)

        return view
    }
    
}

