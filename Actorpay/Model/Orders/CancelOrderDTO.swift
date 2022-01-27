import Foundation
import SwiftyJSON

struct CancelOrderDTO {
    
	let refundAmount : Double?
	let cancelReason : String?
	let cancelOrderItemDTOs : [CancelOrderItemDTOs]?

    init(json: JSON) {

        refundAmount = json["refundAmount"].double
        cancelReason = json["cancelReason"].string
        cancelOrderItemDTOs = json["cancelOrderItemDTOs"].arrayValue.map{ CancelOrderItemDTOs(json: $0)}
	}

}
