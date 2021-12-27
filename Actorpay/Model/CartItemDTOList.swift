import Foundation
import SwiftyJSON

public class CartItemDTOList {
    public var createdAt : String?
    public var cartItemId : String?
    public var productName : String?
    public var productId : String?
    public var productPrice : Double?
    public var productQty : Int?
    public var productSgst : Double?
    public var productCgst : Double?
    public var userDTO : UserDTO?
    public var merchantId : String?
    public var merchantName : String?
    public var totalPrice : Double?
    public var shippingCharge : Int?
    public var taxPercentage : Double?
    public var taxableValue : Double?
    public var email : String?
    public var image : String?
    public var active : Bool?
    
    init(json: JSON) {
        createdAt = json["createdAt"].string
        cartItemId = json["cartItemId"].string
        productName = json["productName"].string
        productId = json["productId"].string
        productPrice = json["productPrice"].double
        productQty = json["productQty"].int
        productSgst = json["productSgst"].double
        productCgst = json["productCgst"].double
        userDTO = UserDTO(json: json["userDTO"])
        merchantId = json["merchantId"].string
        merchantName = json["merchantName"].string
        totalPrice = json["totalPrice"].double
        shippingCharge = json["shippingCharge"].int
        taxPercentage = json["taxPercentage"].double
        taxableValue = json["taxableValue"].double
        email = json["email"].string
        image = json["image"].string
        active = json["active"].bool
    }
    
}

