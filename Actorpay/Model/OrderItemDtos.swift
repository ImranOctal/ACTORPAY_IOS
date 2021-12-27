//
//  OrderItemDtos.swift
//  Actorpay
//
//  Created by iMac on 21/12/21.
//

import Foundation
import SwiftyJSON

struct OrderItemDtos {
    let createdAt : String?
    let productId : String?
    let productPrice : Double?
    let productQty : Int?
    let productSgst : Double?
    let productCgst : Double?
    let totalPrice : Double?
    let shippingCharge : Int?
    let taxPercentage : Double?
    let taxableValue : Double?
    let active : Bool?
    
    init(json: JSON) {
        createdAt = json["createdAt"].string
        productId = json["productId"].string
        productPrice = json["productPrice"].double
        productQty = json["productQty"].int
        productSgst = json["productSgst"].double
        productCgst = json["productCgst"].double
        totalPrice = json["totalPrice"].double
        shippingCharge = json["shippingCharge"].int
        taxPercentage = json["taxPercentage"].double
        taxableValue = json["taxableValue"].double
        active  = json["active"].bool        
    }
    
    
}
