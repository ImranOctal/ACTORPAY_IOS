//
//  DTHRechageViewController.swift
//  Actorpay
//
//  Created by iMac on 08/12/21.
//

import UIKit

class DTHRechageViewController: UIViewController {

    //MARK: - Properties -
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    
    var operatorArray: [String] = ["Airtel","Digi","TataSky"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topCorner(bgView: mainView, maskToBounds: true)
        collectionView.delegate = self
        collectionView.dataSource = self
        // Do any additional setup after loading the view.
    }

    @IBAction func specialPlanBUttonAction(_ sender: UIButton) {
    }
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func rechageNowButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
    }
}

extension DTHRechageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return operatorArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RechargeOperatorCollectionViewCell", for: indexPath) as! RechargeOperatorCollectionViewCell
        cell.iconImageView.image = UIImage(named: operatorArray[indexPath.row])
        cell.titleLabel.text = operatorArray[indexPath.row]
        return cell
    }
}
