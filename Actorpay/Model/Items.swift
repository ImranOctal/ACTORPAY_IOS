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
    public var actualPrice : Float?
    public var dealPrice : Float?
    public var image : String?
    public var merchantId : String?
    public var stockCount : Int?
    public var taxId : String?
    public var stockStatus : String?
    public var status : Bool?
    public var sgst : Float?
    public var cgst : Float?
    public var productTaxId : String?
    public var createdAt : String?
    public var updatedAt : String?
    
    init(json: JSON) {
        productId = json["productId"].string
        name = json["name"].string
        description = json["description"].string
        categoryId = json["categoryId"].string
        subCategoryId = json["subCategoryId"].string
        actualPrice = json["actualPrice"].float
        dealPrice = json["dealPrice"].float
        image = json["image"].string
        merchantId = json["merchantId"].string
        stockCount = json["stockCount"].int
        taxId = json["taxId"].string
        stockStatus = json["stockStatus"].string
        status = json["status"].bool
        sgst = json["sgst"].float
        cgst = json["cgst"].float
        productTaxId = json["productTaxId"].string
        createdAt = json["createdAt"].string
        updatedAt = json["updatedAt"].string        
    }
}
