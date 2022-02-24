import Foundation
import SwiftyJSON

struct WalletList {
    
	let totalPages : Int?
	let totalItems : Int?
	let items : [WalletItems]?
	let pageNumber : Int?
	let pageSize : Int?

    init(json: JSON) {
        totalPages = json["totalPages"].int
        totalItems = json["totalItems"].int
        items = json["items"].arrayValue.map{ WalletItems(json: $0)}
        pageNumber = json["pageNumber"].int
        pageSize = json["pageSize"].int
    }

}
