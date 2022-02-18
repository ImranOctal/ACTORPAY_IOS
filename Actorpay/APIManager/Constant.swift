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
    case socialLogin = "user-service/users/social/signup"
    case register = "user-service/users/signup"
    case userUpdate = "user-service/users/update"
    case changePassword = "user-service/users/change/password"
    case forgetPassword = "user-service/users/forget/password"
    case resetPassword = "user-service/users/reset/password"
    case get_user_details_by_id = "user-service/users/by/id/"
    case getAllCategories = "user-service/get/all/categories/paged"
    case productList = "user-service/products"
    case orderList = "user-service/orders/list/paged"
    case allOrders = "user-service/orders"
    case addToCart = "user-service/cartitems/add"
    case cartItemList = "user-service/cartitems/view"
    case clearCartItemApi = "user-service/cartitems/clear"
    case faqAll = "cms-service/faq/all"
    case removeCartItem = "user-service/cartitems/remove"
    case updateCartItem = "user-service/cartitems/update"
    case productListApi = "user-service/products/list/paged"
    case getUserWalletDetails = "user-service/users/get/wallet/details"
    case cancelOrReturnOrder = "user-service/orders/cancel/"
    case updateOrderStatus = "user-service/orders/status/failed"
    case getAvailabelOfferForCustomer = "user-service/offers/available"
    case country = "global-service/v1/country/get/all"
    case shippingAddressList = "user-service/get/all/user/shipping/address"
    case staticContentApi = "cms-service/get/static/data/by/cms"
    case addAddress = "user-service/add/new/shipping/address"
    case deleteAddress = "user-service/delete/saved/shipping/address/ids"
    case updateAddress = "user-service/update/shipping/address"
    case sendOTP = "user-service/users/phone/otp/request"
    case verifyOTP = "user-service/users/phone/verify"
    case postOrderNoteApi = "user-service/orderNotes/post"
    case disputeListApi = "user-service/dispute/list/paged"
    case disputeDetailsApi = "user-service/dispute/get"
    case send_message = "user-service/dispute/send/message"
    case raiseDispute = "user-service/dispute/raise" 
}

struct MessageConstant {
    static let noNetwork = "No network connection"
    static let someError = "Some error occured"
    static let noData = "There is no content to be displayed"
    static let sslPinningError = "SSL Pinning Error found."

}
