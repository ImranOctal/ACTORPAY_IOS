//
//  OrderItems.swift
//  Actorpay
//
//  Created by iMac on 30/12/21.
//

import Foundation
import SwiftyJSON

struct OrderItems {
    let orderId : String?
    let orderNo : String?
    let totalQuantity : Int?
    let totalPrice : Double?
    let totalSgst : Double?
    let totalCgst : Double?
    let customer : User?
    let merchantId : String?
    let orderStatus : String?
    let cancelOrderDTO : CancelOrderDTO?
    let merchantDTO : MerchantDTO?
    let orderItemDtos : [OrderItemDtos]?
    let createdAt : String?
    let shippingAddressDTO : ShippingAddressDTO?
    let orderNotesDtos : [OrderNotesDtos]?
    let totalTaxableValue : Double?
    
    init(json: JSON) {
        orderId = json["orderId"].string
        orderNo = json["orderNo"].string
        totalQuantity = json["totalQuantity"].int
        totalPrice = json["totalPrice"].double
        totalSgst = json["totalSgst"].double
        totalCgst = json["totalCgst"].double
        customer = User(json: json["customer"])
        merchantId = json["merchantId"].string
        orderStatus = json["orderStatus"].string
        cancelOrderDTO = CancelOrderDTO(json: json["cancelOrderDTO"])
        merchantDTO = MerchantDTO(json: json["merchantDTO"])
        orderItemDtos = json["orderItemDtos"].arrayValue.map{ OrderItemDtos(json: $0)}
        createdAt = json["createdAt"].string
        shippingAddressDTO = ShippingAddressDTO(json: json["shippingAddressDTO"])
        orderNotesDtos = json["orderNotesDtos"].arrayValue.map{OrderNotesDtos(json: $0)}
        totalTaxableValue = json["totalTaxableValue"].double
    }
}
