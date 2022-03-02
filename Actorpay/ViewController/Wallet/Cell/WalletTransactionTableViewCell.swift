//
//  WalletTransactionTableViewCell.swift
//  Actorpay
//
//  Created by iMac on 23/02/22.
//

import UIKit

class WalletTransactionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var transactionIdLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var transactionRemarkLbl: UILabel!
    
    var item: WalletItems? {
        didSet {
            if let item = self.item {
                amountLbl.text = "\(item.transactionTypes == "DEBIT" ? "-" : "+") ₹\(item.transactionAmount ?? 0.0)"
                transactionIdLbl.text = item.walletTransactionId
                dateLbl.text = item.createdAt?.toFormatedDate(from: "yyyy-MM-dd HH:mm", to: "dd MMM yyyy HH:MM")
                titleLbl.text = purchaseType(purchaseType: item.purchaseType ?? "")
                amountLbl.textColor = transactionType(transactionType: item.transactionTypes ?? "")
                transactionRemarkLbl.text = item.transactionRemark
            }
        }
    }


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
