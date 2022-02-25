import Foundation
import SwiftyJSON

struct UserDetails {
    
	let id : String?
	let firstName : String?
	let lastName : String?
	let gender : String?
	let dateOfBirth : String?
	let email : String?
	let extensionNumber : String?
	let contactNumber : String?
	let userType : String?
	let createdAt : String?
	let updatedAt : String?
	let phoneVerified : Bool?
	let emailVerified : Bool?
	let roles : [String]?
	let active : Bool?
	let kycDone : Bool?

    init(json: JSON) {

        id = json["id"].string
        firstName = json["firstName"].string
        lastName = json["lastName"].string
        gender = json["gender"].string
        dateOfBirth = json["dateOfBirth"].string
        email = json["email"].string
        extensionNumber = json["extensionNumber"].string
        contactNumber = json["contactNumber"].string
        userType = json["userType"].string
        createdAt = json["createdAt"].string
        updatedAt = json["updatedAt"].string
        phoneVerified = json["phoneVerified"].bool
        emailVerified = json["emailVerified"].bool
        roles = json["roles"].arrayObject as? [String]
        active = json["active"].bool
        kycDone = json["kycDone"].bool
	}
    
}
