import Foundation
import SwiftyJSON

public class UserDTO {
    public var id : String?
    public var roles : Array<String>?
    public var kycDone : Bool?
    
    init(json: JSON) {
        id = json["id"].string
        roles = json["roles"].arrayObject as? [String]
        kycDone = json["kycDone"].bool
    }
    
}
