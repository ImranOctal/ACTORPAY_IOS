//
//  Wallet.swift
//  Actorpay
//
//  Created by iMac on 03/01/22.
//

import Foundation
import SwiftyJSON

var walletData : Wallet?

struct Wallet {
    
    let id : String?
    let userId : String?
    let amount : Double?
    let walletCode : String?
    let createdAt : String?
    let updatedAt : String?
    let userType: String?
    let active: Bool?
    
    
    
    init(json: JSON) {
        id = json["id"].string
        userId = json["userId"].string
        amount = json["amount"].double
        walletCode = json["walletCode"].string
        createdAt = json["createdAt"].string
        updatedAt = json["updatedAt"].string
        userType = json["userType"].string
        active = json["active"].bool
    }
    
}
