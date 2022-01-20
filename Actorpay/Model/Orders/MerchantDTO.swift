//
//  MerchantDTO.swift
//  Actorpay
//
//  Created by iMac on 18/01/22.
//

import Foundation
import SwiftyJSON

struct MerchantDTO {
    public var active : Bool?
    public var extensionNumber : String?
    public var licenceNumber : String?
    public var updatedAt : String?
    public var resourceType : String?
    public var createdAt : String?
    public var profilePicture : String?
    public var id : String?
    public var merchantId : String?
    public var shopAddress : String?
    public var businessName : String?
    public var fullAddress : String?
    public var contactNumber : String?
    public var email : String?
    public var password : String?
    
    init(json: JSON) {
        createdAt = json["createdAt"].string
        updatedAt = json["updatedAt"].string
        active = json["active"].bool
        extensionNumber = json["extensionNumber"].string
        licenceNumber = json["licenceNumber"].string
        resourceType = json["resourceType"].string
        profilePicture = json["profilePicture"].string
        id = json["id"].string
        merchantId = json["merchantId"].string
        shopAddress = json["shopAddress"].string
        businessName = json["businessName"].string
        fullAddress = json["fullAddress"].string
        contactNumber = json["contactNumber"].string
        email  = json["email"].string
        password  = json["password"].string
    }
    
}

