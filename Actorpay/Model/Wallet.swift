//
//  Wallet.swift
//  Actorpay
//
//  Created by iMac on 03/01/22.
//

import Foundation
import SwiftyJSON

struct Wallet {
    
    let id : String?
    let userId : String?
    let amount : Double?
    let walletCode : String?
    
    init(json: JSON) {
        id = json["id"].string
        userId = json["userId"].string
        amount = json["amount"].double
        walletCode = json["walletCode"].string
    }
    
}
