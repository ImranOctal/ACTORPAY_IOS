import Foundation
import SwiftyJSON

struct WalletItems {
    
	let createdAt : String?
	let updatedAt : String?
	let walletTransactionId : String?
	let transactionAmount : Double?
	let transactionTypes : String?
	let userType : String?
	let userId : String?
	let walletId : String?
	let toUser : String?
	let adminCommission : Double?
	let transferAmount : Double?
	let purchaseType : String?
	let transactionRemark : String?
	let percentage : Double?
	let active : Bool?

    init(json: JSON) {
        createdAt = json["createdAt"].string
        updatedAt = json["updatedAt"].string
        walletTransactionId = json["walletTransactionId"].string
        transactionAmount = json["transactionAmount"].double
        transactionTypes = json["transactionTypes"].string
        userType = json["userType"].string
        userId = json["userId"].string
        walletId = json["walletId"].string
        toUser = json["toUser"].string
        adminCommission = json["adminCommission"].double
        transferAmount = json["transferAmount"].double
        purchaseType = json["purchaseType"].string
        transactionRemark = json["transactionRemark"].string
        percentage = json["percentage"].double
        active = json["active"].bool
	}

}
