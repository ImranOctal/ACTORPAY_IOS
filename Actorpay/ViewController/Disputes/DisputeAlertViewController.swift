//
//  DisputeAlertViewController.swift
//  Actorpay
//
//  Created by iMac on 17/02/22.
//

import UIKit

class DisputeAlertViewController: UIViewController {
    
    //MARK: - Properties -

    @IBOutlet weak var disputeCodeLbl: UILabel!
    @IBOutlet weak var disputeTitleLbl: UILabel!
    @IBOutlet weak var disputeStatusLbl: UILabel!
    
    //MARK: - Life Cycles -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    //MARK: - Selectors -
    
    // OK Button Action
    @IBAction func okBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Helper Functions -
    
    // Setup Dispute Alert
    func setUpDisputeAlert(disputeTitle: String,disputeCode: String, disputeStatus: String) {
        disputeCodeLbl.text = disputeCode
        disputeTitleLbl.text = disputeTitle
        disputeStatusLbl.text = disputeStatus
    }

}
