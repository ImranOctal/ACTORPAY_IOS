//
//  Items.swift
//  Actorpay
//
//  Created by iMac on 21/12/21.
//

import Foundation
import SwiftyJSON

public class Items {
    
    public var productId : String?
    public var name : String?
    public var description : String?
    public var categoryId : String?
    public var subCategoryId : String?
    public var actualPrice : Double?
    public var dealPrice : Double?
    public var image : String?
    public var merchantId : String?
    public var stockCount : Int?
    public var taxId : String?
    public var stockStatus : String?
    public var status : Bool?
    public var sgst : Double?
    public var cgst : Double?
    public var productTaxId : String?
    public var createdAt : String?
    public var updatedAt : String?
    
    public var offerId : String?
    public var offerTitle : String?
    public var offerDescription : String?
    public var offerInPercentage : Double?
    public var promoCode : String?
//    public var categoryId : String?
    public var offerType : String?
//    public var createdAt : String?
//    public var updatedAt : String?
    public var numberOfUsage : Int?
    public var ordersPerDay : Int?
    public var visibilityLevel : String?
    public var active : Bool?
    
    init(json: JSON) {
        productId = json["productId"].string
        name = json["name"].string
        description = json["description"].string
        categoryId = json["categoryId"].string
        subCategoryId = json["subCategoryId"].string
        actualPrice = json["actualPrice"].double
        dealPrice = json["dealPrice"].double
        image = json["image"].string
        merchantId = json["merchantId"].string
        stockCount = json["stockCount"].int
        taxId = json["taxId"].string
        stockStatus = json["stockStatus"].string
        status = json["status"].bool
        sgst = json["sgst"].double
        cgst = json["cgst"].double
        productTaxId = json["productTaxId"].string
        createdAt = json["createdAt"].string
        updatedAt = json["updatedAt"].string        
        
        offerId = json["offerId"].string
        offerTitle = json["offerTitle"].string
        offerDescription = json["offerDescription"].string
        offerInPercentage = json["offerInPercentage"].double
        promoCode = json["promoCode"].string
        offerType = json["offerType"].string
        numberOfUsage = json["numberOfUsage"].int
        ordersPerDay = json["ordersPerDay"].int
        active = json["active"].bool
        visibilityLevel = json["visibilityLevel"].string
        
        
    }
}
