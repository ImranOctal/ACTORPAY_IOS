//
//  MerchantDTO.swift
//  Actorpay
//
//  Created by iMac on 18/01/22.
//

import Foundation
import SwiftyJSON

struct MerchantDTO {
    let createdAt : String?
    let updatedAt : String?
    let id : String?
    let email : String?
    let merchantId : String?
    let extensionNumber : String?
    let contactNumber : String?
    let profilePicture : String?
    let password : String?
    let resourceType : String?
    let businessName : String?
    let fullAddress : String?
    let shopAddress : String?
    let licenceNumber : String?
    let active : Bool?
    
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

