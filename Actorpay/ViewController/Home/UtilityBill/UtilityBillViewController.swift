//
//  UtilityBillViewController.swift
//  Actorpay
//
//  Created by iMac on 08/12/21.
//

import UIKit
import DropDown

class UtilityBillViewController: UIViewController {

    //MARK: - Properties -
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var selectUtilityTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    
    var utilityBillArray: [String] = ["Gas","Water","Electricity","Gas","Water","Electricity"]
    let dropDown = DropDown()
    
    //MARK:- Life Cycle Functions -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topCorner(bgView: mainView, maskToBounds: true)
        collectionView.delegate = self
        collectionView.dataSource = self
        setupDropDown()
        // Do any additional setup after loading the view.
    }

    @IBAction func selectUtilityDropDown(_ sender: UIButton) {
        self.view.endEditing(true)
        dropDown.show()
    }
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func proceedButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if selectUtilityTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            self.alertViewController(message: "Please select an Utility bill.")
//            self.view.makeToast("Please enter a Baneficiary Name.", duration: 3.0, position: .bottom)
            return
        }
        if numberTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            self.alertViewController(message: "Please enter a number.")
            return
        }
        if amountTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            self.alertViewController(message: "Please enter an amount.")
            return
        }
    }
    
    func setupDropDown()  {
        dropDown.anchorView = selectUtilityTextField
        dropDown.dataSource = ["Indian Gas","Bharat Gas","DGVCL","PGVCL"]
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.selectUtilityTextField.text = item
            self.view.endEditing(true)
            self.dropDown.hide()
        }
        dropDown.bottomOffset = CGPoint(x: 0, y: 50)
        dropDown.direction = .bottom
        dropDown.backgroundColor = .white
    }
    
}

extension UtilityBillViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return utilityBillArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UtilityBillCollectionViewCell", for: indexPath) as! UtilityBillCollectionViewCell
        cell.iconImageView.image = UIImage(named: utilityBillArray[indexPath.row])
        cell.titleLabel.text = utilityBillArray[indexPath.row]
        return cell
    }
}
