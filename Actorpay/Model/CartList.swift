import Foundation
import SwiftyJSON

public class CartList {
    public var totalQuantity : Int?
    public var totalPrice : Double?
    public var totalSgst : Double?
    public var totalCgst : Double?
    public var userId : String?
    public var merchantId : String?
    public var merchantName : String?
    public var cartItemDTOList : [CartItemDTOList]?
    public var totalTaxableValue : Double?

	init(json: JSON) {
        totalQuantity = json["totalQuantity"].int
        totalPrice = json["totalPrice"].double
		totalSgst = json["totalSgst"].double
		totalCgst = json["totalCgst"].double
		userId = json["userId"].string
		merchantId = json["merchantId"].string
		merchantName = json["merchantName"].string
        cartItemDTOList = json["cartItemDTOList"].arrayValue.map{ CartItemDTOList(json: $0)}
		totalTaxableValue = json["totalTaxableValue"].double
	}

}
