import Foundation
import SwiftyJSON

struct AddressList {
	
    let totalPages : Int?
	let totalItems : Int?
	let items : [AddressItems]?
	let pageNumber : Int?
	let pageSize : Int?

    init(json: JSON) {

        totalPages = json["totalPages"].int
        totalItems = json["totalItems"].int
        items = json["items"].arrayValue.map{ AddressItems(json: $0)}
        pageNumber = json["pageNumber"].int
        pageSize = json["pageSize"].int
	}

}
