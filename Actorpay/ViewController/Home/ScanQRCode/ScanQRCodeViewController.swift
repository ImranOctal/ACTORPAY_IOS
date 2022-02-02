//
//  ScanQRCodeViewController.swift
//  Actorpay
//
//  Created by iMac on 08/12/21.
//

import UIKit
//import SwiftQRScanner

class ScanQRCodeViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var qrCodeView: UIView!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var proceedButton: UIButton!
    @IBOutlet weak var proceedButtonView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topCorner(bgView: mainView, maskToBounds: true)
        phoneNumberTextField.delegate = self
        proceedButtonView.isHidden = true
        // Do any additional setup after loading the view.
        DispatchQueue.main.async {
            let scanner = QRCodeScannerController()
            scanner.delegate = self
            self.add(asChildViewController: scanner)
        }
        phoneNumberTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
    }

    @objc func textFieldDidChange(textField : UITextField){
        if (textField.text?.count ?? 0 < 5) {
            proceedButtonView.isHidden = true
        }else{
            proceedButtonView.isHidden = false
        }
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    private func add(asChildViewController viewController: UIViewController) {
        addChild(viewController)
        qrCodeView.addSubview(viewController.view)
        viewController.view.frame = qrCodeView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParent: self)
    }
    
}

extension ScanQRCodeViewController: QRScannerCodeDelegate {
    func qrScanner(_ controller: UIViewController, scanDidComplete result: String) {
        
        //        guard let url = URL(string: result) else {
        //          return //be safe
        //        }
        //
        //        if #available(iOS 10.0, *) {
        //            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        //        } else {
        //            UIApplication.shared.openURL(url)
        //        }
//
        //        Helpers.processQRScan(self, result)
        print(result)
        if result.count != 0{
            let newVC = self.storyboard?.instantiateViewController(withIdentifier: "QRCodePayNowViewController") as! QRCodePayNowViewController
            self.navigationController?.pushViewController(newVC, animated: true)
        }
//        payNowView.isHidden = (result == "") ? true : false
        
        //searchUsers(result)
    }
    
    func qrScannerDidFail(_ controller: UIViewController, error: String) {
        print("error:\(error)")
    }
    
    func qrScannerDidCancel(_ controller: UIViewController) {
        print("SwiftQRScanner did cancel")
    }
}
