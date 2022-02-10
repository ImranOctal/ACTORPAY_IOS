//
//  AddMoneyInWalletViewController.swift
//  Actorpay
//
//  Created by iMac on 09/02/22.
//

import UIKit

class AddMoneyInWalletViewController: UIViewController {
    
    // MARK: - Properties -
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var addMoneyAmountCollectionView: UICollectionView! {
        didSet {
            self.addMoneyAmountCollectionView.delegate = self
            self.addMoneyAmountCollectionView.dataSource = self
        }
    }
    @IBOutlet weak var amountTextField: UITextField! {
        didSet {
            self.amountTextField.delegate = self
        }
    }
    @IBOutlet weak var amountValidationLbl: UILabel!
    
    var addMoneyAmountArr = [50,100,200,500,1000,2000]

    //MARK: - Life Cycles -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        topCorner(bgView: bgView, maskToBounds: true)
        self.manageValidationLabel()
    }
    
    //MARK: - Selectors -
    
    // Back Button Action
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    // Add Money Button Action
    @IBAction func addMoneyBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if addMoneyInWalletValidation() {
            self.manageValidationLabel()
            let newVC = self.storyboard?.instantiateViewController(withIdentifier: "DummyTransactionViewController") as! DummyTransactionViewController
            self.navigationController?.pushViewController(newVC, animated: true)
        }
    }
    
    //MARK: - Helper Functions -
    
    // Validation Label Manage
    func manageValidationLabel() {
        self.amountValidationLbl.isHidden = true
    }
    
    // Add Money In Wallet Validation
    func addMoneyInWalletValidation() -> Bool {
        var isValidate = true
        
        if amountTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            self.amountValidationLbl.isHidden = false
            self.amountValidationLbl.text = ValidationManager.shared.emptyAmount
            isValidate = false
        } else {
            self.amountValidationLbl.isHidden = true
        }
        
        return isValidate
    }
    
}

//MARK: - Extensions -

//MARK: Collection View Setup
extension AddMoneyInWalletViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return addMoneyAmountArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddMoneyAmountCollectionViewCell", for: indexPath) as! AddMoneyAmountCollectionViewCell
        cell.addMoneyAmountLabel.text = "\(addMoneyAmountArr[indexPath.row])"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.amountTextField.text = "\(addMoneyAmountArr[indexPath.row])"
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((collectionView.frame.width) / 3.5), height: 40 )
    }
    
}

// MARK: - TextField Delegate Methods
extension AddMoneyInWalletViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        switch textField {
        case amountTextField:
            if amountTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
                self.amountValidationLbl.isHidden = false
                self.amountValidationLbl.text = ValidationManager.shared.emptyAmount
            } else {
                self.amountValidationLbl.isHidden = true
            }
        default:
            break
        }
    }
    
}
