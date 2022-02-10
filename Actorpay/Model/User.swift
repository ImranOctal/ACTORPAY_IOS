//
//  User.swift
//  Actorpay
//
//  Created by iMac on 20/12/21.
//

import Foundation
import SwiftyJSON

var user: User?

struct User {
    
    let id : String?
    let firstName : String?
    let lastName : String?
    let email : String?
    let access_token : String?
    let refresh_token : String?
    let token_type : String?
    var gender : String?
    var dateOfBirth : String?
    var extensionNumber : String?
    var contactNumber : String?
    var userType : String?
    var invalidLoginAttempts : Int?
    var phoneVerified : Bool?
    var emailVerified : Bool?
    var createdAt : String?
    var updatedAt : String?
    var roles : Array<String>?
    var active : Bool?
    var kycDone : Bool?
    let panNumber : String?
    let aadharNumber : String?
    
    init(json: JSON) {
        id = json["id"].string
        firstName = json["firstName"].string
        lastName = json["lastName"].string
        email = json["email"].string
        access_token = json["access_token"].string
        refresh_token = json["refresh_token"].string
        token_type = json["token_type"].string
        gender = json["gender"].string
        dateOfBirth = json["dateOfBirth"].string
        extensionNumber = json["extensionNumber"].string
        contactNumber = json["contactNumber"].string
        userType = json["userType"].string
        invalidLoginAttempts = json["invalidLoginAttempts"].int
        createdAt = json["createdAt"].string
        updatedAt = json["updatedAt"].string
        roles = json["roles"].arrayObject as? [String]
        active = json["active"].bool
        phoneVerified = json["phoneVerified"].bool
        emailVerified = json["emailVerified"].bool
        kycDone = json["kycDone"].bool
        panNumber = json["panNumber"].string
        aadharNumber = json["aadharNumber"].string
    }
    
}
