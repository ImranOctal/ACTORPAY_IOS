//
//  Constant.swift
//  Actorpay
//
//  Created by iMac on 20/12/21.
//

import Foundation

enum APIBaseUrlPoint: String {
    case localHostBaseURL = "http://192.168.1.171:8765/api/"
}

enum APIEndPoint: String {
   
    case login = "user-service/users/login"
    case register = "user-service/users/signup"
    case userUpdate = "user-service/users/update"
    case changePassword = "user-service/users/change/password"
    case forgetPassword = "user-service/users/forget/password"
    case resetPassword = "user-service/users/reset/password"
    case get_user_details_by_id = "user-service/users/by/id/"
    case linkWallet = "link-wallet"
}

struct MessageConstant {
    static let noNetwork = "No network connection"
    static let someError = "Some error occured"
    static let noData = "There is no content to be displayed"
    static let sslPinningError = "SSL Pinning Error found."

}
