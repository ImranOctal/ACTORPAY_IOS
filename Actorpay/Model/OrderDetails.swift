//
//  OrderDetails.swift
//  Actorpay
//
//  Created by iMac on 21/12/21.
//

import Foundation
import SwiftyJSON

struct OrderDetails {
    let totalQuantity : Int?
    let totalPrice : Double?
    let totalSgst : Double?
    let totalCgst : Double?
    let customer : User?
    let merchantId : String?
    let orderStatus : String?
    let orderItemDtos : [OrderItemDtos]?
    let totalTaxableValue : Double?
    
    init(json: JSON) {
        totalQuantity = json["totalQuantity"].int
        totalPrice = json["totalPrice"].double
        totalSgst = json["totalSgst"].double
        totalCgst = json["totalCgst"].double
        customer = User(json: json["customer"])
        merchantId = json["merchantId"].string
        orderStatus = json["orderStatus"].string
        orderItemDtos = json["orderItemDtos"].arrayValue.map{ OrderItemDtos(json: $0)}
        totalTaxableValue = json["totalTaxableValue"].double
    }
    
}
