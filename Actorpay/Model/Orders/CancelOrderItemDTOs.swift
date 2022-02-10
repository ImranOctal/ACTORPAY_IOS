import Foundation
import  SwiftyJSON

struct CancelOrderItemDTOs {
    
	let id : String?
	let orderItemId : String?
	let cancelOrderId : String?
	let createdAt : String?
	let updatedAt : String?
	let refundAmount : Double?
	let active : Bool?

    init(json: JSON) {

        id = json["id"].string
        orderItemId = json["orderItemId"].string
        cancelOrderId = json["cancelOrderId"].string
        createdAt = json["createdAt"].string
        updatedAt = json["updatedAt"].string
        refundAmount = json["refundAmount"].double
        active = json["active"].bool
	}

}
