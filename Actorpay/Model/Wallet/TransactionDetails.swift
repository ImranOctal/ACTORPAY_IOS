//
//  TransactionDetails.swift
//  Actorpay
//
//  Created by iMac on 25/02/22.
//

import Foundation
import SwiftyJSON

struct TransactionDetails {
    
    let walletBalance : Double?
    let transferredAmount : Double?
    let customerName : String?
    let transactionType : String?
    let transactionId : String?
    
    init(json: JSON) {
        walletBalance = json["walletBalance"].double
        transferredAmount = json["transferredAmount"].double
        customerName = json["customerName"].string
        transactionType = json["transactionType"].string
        transactionId = json["transactionId"].string
    }
    
}
