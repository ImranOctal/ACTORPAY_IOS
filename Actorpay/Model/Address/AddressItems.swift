import Foundation
import SwiftyJSON

struct AddressItems {
    
	let addressLine1 : String?
	let addressLine2 : String?
	let zipCode : String?
	let city : String?
	let state : String?
	let country : String?
	let latitude : String?
	let longitude : String?
	let id : String?
	let name : String?
    let extensionNumber : String?
	let primaryContactNumber : String?
	let secondaryContactNumber : String?
	let primary : Bool?
    let area: String?
    let title: String?

    init(json: JSON) {

        addressLine1 = json["addressLine1"].string
        addressLine2 = json["addressLine2"].string
        zipCode = json["zipCode"].string
        city = json["city"].string
        state = json["state"].string
        country = json["country"].string
        latitude = json["latitude"].string
        longitude = json["longitude"].string
        id = json["id"].string
        name = json["name"].string
        area = json["area"].string
        title = json["title"].string
        extensionNumber = json["extensionNumber"].string
        primaryContactNumber = json["primaryContactNumber"].string
        secondaryContactNumber = json["secondaryContactNumber"].string
        primary = json["primary"].bool
	}
    
}
