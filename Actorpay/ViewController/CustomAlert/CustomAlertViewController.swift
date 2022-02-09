//
//  CustomAlertViewController.swift
//  Actorpay
//
//  Created by iMac on 04/01/22.
//

import UIKit

protocol CustomAlertDelegate {
    func okButtonclick()
    func cancelButtonClick()
}

class CustomAlertViewController: UIViewController {
    
    //MARK: - Properties -
    
    @IBOutlet weak var alertTitleLbl: UILabel!
    @IBOutlet weak var alertDescLbl: UILabel!
    @IBOutlet weak var cancelButtonView: UIView!
    @IBOutlet weak var horizontalBorderView: UIView!
    @IBOutlet weak var customAlertView: UIView!
    @IBOutlet weak var alertTitleView: UIView!
    @IBOutlet weak var alertButtonView: UIView!
    @IBOutlet weak var mainView: UIView!
    
    var customAlertDelegate: CustomAlertDelegate?
    
    //MARK: - Life Cycles -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        topCorners(bgView: alertTitleView, cornerRadius: 10, maskToBounds: true)
        bottomCorner(bgView: alertButtonView, cornerRadius: 10, maskToBounds: true)
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        self.showAnimate()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: - Selectors -
    
    // OK Button Action
    @IBAction func okButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        customAlertDelegate?.okButtonclick()
    }
    
    // Cancel Button Action
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        customAlertDelegate?.cancelButtonClick()
    }
    
    //MARK: - Helper Functions -
    
    // Setup Custom Alert
    func setUpCustomAlert(titleStr: String, descriptionStr: String ,isShowCancelBtn:Bool) {
        alertTitleLbl.text = titleStr
        alertDescLbl.text = descriptionStr
        cancelButtonView.isHidden = isShowCancelBtn
    }
    
    // Present View With Animation
    func showAnimate(){
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    // Remove View With Animation
    func removeAnimate(){
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished){
                self.view.endEditing(true)
                self.view.removeFromSuperview()
            }
        });
    }
    
    // View End Editing
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let currentPoint = touch.location(in: self.mainView)
            print(currentPoint)
            if !(customAlertView.frame.contains(currentPoint)) {
                removeAnimate()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }    
}

