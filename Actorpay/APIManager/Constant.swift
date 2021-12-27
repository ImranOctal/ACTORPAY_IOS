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
    case productList = "user-service/products"
    case allOrders = "user-service/orders"
    case addToCart = "user-service/cartitems/add"
    case cartItemList = "user-service/cartitems/view"
    case faqAll = "cms-service/faq/all"
    case removeCartItem = "user-service/cartitems/remove"
    case updateCartItem = "user-service/cartitems/update"
}

struct MessageConstant {
    static let noNetwork = "No network connection"
    static let someError = "Some error occured"
    static let noData = "There is no content to be displayed"
    static let sslPinningError = "SSL Pinning Error found."

}
