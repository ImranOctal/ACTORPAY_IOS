//
//  APIHelper.swift
//  Actorpay
//
//  Created by iMac on 20/12/21.
//

import Foundation
import SwiftyJSON
import Alamofire

final class APIHelper {
    
    //MARK: Login Api
    static func loginUser(params: Parameters,success:@escaping (_ success: Bool,_ response: APIResponse) -> Void ){
        APIManager.shared.request(method: .post, url: APIEndPoint.login.rawValue, parameters: params) { (response) in
            let status = response.response["status"]
            if status == "200" {
                success(true, response)
            }else {
                success(false, response)
            }
        }
    }
    
    //MARK: Social Login Api
    static func socialLoginApi(params: Parameters,success:@escaping (_ success: Bool,_ response: APIResponse) -> Void ){
        APIManager.shared.request(method: .post, url: APIEndPoint.socialLogin.rawValue, parameters: params) { (response) in
            let status = response.response["status"]
            if status == "200" {
                success(true, response)
            }else {
                success(false, response)
            }
        }
    }
    
    //MARK: SignUp Api
    static func registerUser(params: Parameters,success:@escaping (_ success: Bool,_ response: APIResponse) -> Void ){
        APIManager.shared.request(method: .post, url: APIEndPoint.register.rawValue, parameters: params) { (response) in
            let status = response.response["status"]
            if status == "200" {
                success(true, response)
            }else {
                success(false, response)
            }
        }
    }
    
    //MARK: Update User APi
    static func updateUser(params: Parameters,success:@escaping (_ success: Bool,_ response: APIResponse) -> Void ){
        APIManager.shared.putRequest(url: APIEndPoint.userUpdate.rawValue, parameters: params) { (response) in
            let status = response.response["status"]
            if status == "200" {
                success(true, response)
            }else {
                success(false, response)
            }
        }
    }
    
    //MARK: Forgot Password Api
    static func forgotPassword(params: Parameters , success:@escaping (_ success: Bool,_ response: APIResponse) -> Void){
        APIManager.shared.request(method: .post, url: APIEndPoint.forgetPassword.rawValue, parameters: params) { (response) in
            let status = response.response["status"]
            if status == "200" {
                success(true, response)
            }else {
                success(false, response)
            }
        }
    }
    
    //MARK: Change Password Api
    static func changePassword(params: Parameters , success:@escaping (_ success: Bool,_ response: APIResponse) -> Void){
        APIManager.shared.request2(method: .post, url: APIEndPoint.changePassword.rawValue, parameters: params) { (response) in
            let status = response.response["status"]
            if status == "200" {
                success(true, response)
            }else {
                success(false, response)
            }
        }
    }
    
    //MARK: Reset Password Api
    static func resetPassword(params: Parameters , success:@escaping (_ success: Bool,_ response: APIResponse) -> Void){
        APIManager.shared.request2(method: .post, url: APIEndPoint.resetPassword.rawValue, parameters: params) { (response) in
            let status = response.response["status"]
            if status == "200" {
                success(true, response)
            }else {
                success(false, response)
            }
        }
    }
                
    //MARK: Get User Details Api
    static func getUserDetailsById(id: String, success:@escaping (_ success: Bool,_ response: APIResponse) -> Void){
        APIManager.shared.getMethod(url: APIEndPoint.get_user_details_by_id.rawValue + "\(id)") { (response) in
            let status = response.response["status"]
            if status == "200" {
                success(true, response)
            }else {
                success(false, response)
            }
        }
    }
    
    //MARK: Get All Category Api
    static func getAllCategoriesAPI(parameters: Parameters,success:@escaping (_ success: Bool,_ response: APIResponse) -> Void){
        APIManager.shared.getMethod(url: APIEndPoint.getAllCategories.rawValue, parameters: parameters) { (response) in
            let status = response.response["status"]
            if status == "200" {
                success(true, response)
            }else {
                success(false, response)
            }
        }
    }
    
    //MARK: Product List Api
    static func productListApi(urlParameters: Parameters, bodyParameter:Parameters, success:@escaping (_ success: Bool,_ response: APIResponse) -> Void){
        APIManager.shared.mainRequest(method: .post,url: APIEndPoint.productListApi.rawValue, urlParameters: urlParameters, bodyParameter: bodyParameter, needUserToken: true) { (response) in
            let status = response.response["status"]
            if status == "200" {
                success(true, response)
            }else {
                success(false, response)
            }
        }
    }
    
    //MARK: Place Order API
    static func placeOrderAPI(params: Parameters , success:@escaping (_ success: Bool,_ response: APIResponse) -> Void){
        APIManager.shared.request2(method: .post, url: APIEndPoint.allOrders.rawValue, parameters: params) { (response) in
            let status = response.response["status"]
            if status == "200" {
                success(true, response)
            }else {
                success(false, response)
            }
        }
    }
    
    //MARK: Product Details Api
    static func getProductDetails(id: String ,success:@escaping (_ success: Bool,_ response: APIResponse) -> Void){
        APIManager.shared.getMethod(url: APIEndPoint.productList.rawValue + "/\(id)") { (response) in
            let status = response.response["status"]
            if status == "200" {
                success(true, response)
            }else {
                success(false, response)
            }
        }
    }
    
    //MARK: Add to cart Api
    static func addToCartProduct(params: Parameters , success:@escaping (_ success: Bool,_ response: APIResponse) -> Void){
        APIManager.shared.request2(method: .post, url: APIEndPoint.addToCart.rawValue, parameters: params) { (response) in
            let status = response.response["status"]
            if status == "200" {
                success(true, response)
            }else {
                success(false, response)
            }
        }
    }
    
    //MARK: Cart Item List Api
    static func getCartItemsList(parameters: Parameters ,success:@escaping (_ success: Bool,_ response: APIResponse) -> Void){
        APIManager.shared.getMethod(method: .get, url: APIEndPoint.cartItemList.rawValue, parameters: parameters) { (response) in
            let status = response.response["status"]
            if status == "200" {
                success(true, response)
            }else {
                success(false, response)
            }
        }
    }
    
    //MARK: Remove Item From Cart Api
    static func removeCartItem(id: String , success:@escaping (_ success: Bool,_ response: APIResponse) -> Void){
        APIManager.shared.request2(method: .delete, url: APIEndPoint.removeCartItem.rawValue+"/"+id, parameters: [:]) { (response) in
            let status = response.response["status"]
            if status == "200" {
                success(true, response)
            }else {
                success(false, response)
            }
        }
    }
    
    //MARK: Update Cart Item Api
    static func updateCartItem(params: Parameters , success:@escaping (_ success: Bool,_ response: APIResponse) -> Void){
        APIManager.shared.request2(method: .put, url: APIEndPoint.updateCartItem.rawValue, parameters: params) { (response) in
            let status = response.response["status"]
            if status == "200" {
                success(true, response)
            }else {
                success(false, response)
            }
        }
    }
    
    //MARK: SignUp Api
    static func addAddressAPI(params: Parameters,success:@escaping (_ success: Bool,_ response: APIResponse) -> Void ){
        APIManager.shared.request2(method: .post, url: APIEndPoint.addAddress.rawValue, parameters: params) { (response) in
            let status = response.response["status"]
            if status == "200" {
                success(true, response)
            }else {
                success(false, response)
            }
        }
    }
    
    //MARK:  Verify OTP Api
    static func verifyOTPAPI(urlParameters: Parameters,success:@escaping (_ success: Bool,_ response: APIResponse) -> Void ){
        APIManager.shared.mainRequest(method: .post, url: APIEndPoint.verifyOTP.rawValue, urlParameters: urlParameters, bodyParameter: [:], needUserToken: true) { (response) in
            let status = response.response["status"]
            if status == "200" {
                success(true, response)
            }else {
                success(false, response)
            }
        }
    }
    
    
    //MARK: Get All Order List Api
    static func getAllOrders( urlParameters: Parameters, bodyParameter:Parameters,success:@escaping (_ success: Bool,_ response: APIResponse) -> Void) {
        APIManager.shared.mainRequest(method: .post, url: APIEndPoint.orderList.rawValue, urlParameters: urlParameters, bodyParameter: bodyParameter, needUserToken: true) { (response) in
            let status = response.response["status"]
            if status == "200" {
                success(true, response)
            }else {
                success(false, response)
            }
        }
    }
    
    //MARK: Order Details Api
    static func getOrderDetailsApi(orderNo: String ,success:@escaping (_ success: Bool,_ response: APIResponse) -> Void) {
        APIManager.shared.getMethod(url: APIEndPoint.allOrders.rawValue + "/\(orderNo)") { (response) in
            let status = response.response["status"]
            if status == "200" {
                success(true, response)
            }else {
                success(false, response)
            }
        }
    }
    //MARK: Cancel Or Return Order Api
    static func getOTPRequestAPI(success:@escaping (_ success: Bool,_ response: APIResponse) -> Void){
        APIManager.shared.getMethod(url: APIEndPoint.sendOTP.rawValue) { (response) in
            let status = response.response["status"]
            if status == "200" {
                success(true, response)
            }else {
                success(false, response)
            }
        }
    }
    
    //MARK: Cancel Or Return Order Api
    static func cancelOrReturnOrderApi(params: Parameters, imgData: Data?, imageKey: String,orderNo: String, success:@escaping (_ success: Bool,_ response: APIResponse) -> Void) {
        APIManager.shared.uploadData(method: .post, url: APIEndPoint.cancelOrReturnOrder.rawValue+"\(orderNo)", parameters: params, imgData: imgData, imageKey: imageKey) { (response) in
            let status = response.response["status"]
            if status == "200" {
                success(true, response)
            }else {
                success(false, response)
            }
        }
    }
    
    static func raiseDisputeAPI(params: Parameters, imgData: Data?, imageKey: String, success:@escaping (_ success: Bool,_ response: APIResponse) -> Void) {
        APIManager.shared.uploadData(method: .post, url: APIEndPoint.raiseDispute.rawValue, parameters: params, imgData: imgData, imageKey: imageKey) { (response) in
            let status = response.response["status"]
            if status == "200" {
                success(true, response)
            }else {
                success(false, response)
            }
        }
    }

    
    //MARK: Change Order Status Api
    static func updateOrderStatusApi(params: Parameters , success:@escaping (_ success: Bool,_ response: APIResponse) -> Void) {
        APIManager.shared.request2(method: .put, url: APIEndPoint.updateOrderStatus.rawValue, parameters: params) { (response) in
            let status = response.response["status"]
            if status == "200" {
                success(true, response)
            }else {
                success(false, response)
            }
        }
    }
    
    //MARK: Get User Wallet Details
    static func getUserWalletDetailsApi(params: Parameters , success:@escaping (_ success: Bool,_ response: APIResponse) -> Void) {
        APIManager.shared.request2(method: .post, url: APIEndPoint.getUserWalletDetails.rawValue, parameters: params) { (response) in
            let status = response.response["status"]
            if status == "200" {
                success(true, response)
            }else {
                success(false, response)
            }
        }
    }
    
    //MARK: Get Availabel Offer For Customer
    static func getAvailableOfferForCustomer(params: Parameters,success:@escaping (_ success: Bool,_ response: APIResponse) -> Void ) {
        APIManager.shared.request2(method: .post, url: APIEndPoint.getAvailabelOfferForCustomer.rawValue, parameters: params) { (response) in
            let status = response.response["status"]
            if status == "200" {
                success(true, response)
            }else {
                success(false, response)
            }
        }
    }
    
    // MARK: FAQ Api
    static func getFAQAll(parameters: Parameters ,success:@escaping (_ success: Bool,_ response: APIResponse) -> Void) {
        APIManager.shared.getMethod(method: .get, url: APIEndPoint.faqAll.rawValue, parameters: parameters) { (response) in
            let status = response.response["status"]
            if status == "200" {
                success(true, response)
            }else {
                success(false, response)
            }
        }
    }
    
    //MARK: Country List Api
    static func getCountryListAPI(success:@escaping (_ success: Bool,_ response: APIResponse) -> Void) {
        APIManager.shared.getMethodWithoutAuth(method: .get, url: APIEndPoint.country.rawValue) { (response) in
            let status = response.response["status"]
            if status == "200" {
                success(true, response)
            }else {
                success(false, response)
            }
        }
    }
    
    //MARK: Get All Shipping Address
    static func getAllShippingAddressApi(parameters: Parameters ,success:@escaping (_ success: Bool,_ response: APIResponse) -> Void) {
        APIManager.shared.getMethod(method: .get, url: APIEndPoint.shippingAddressList.rawValue, parameters: parameters) { (response) in
            let status = response.response["status"]
            if status == "200" {
                success(true, response)
            }else {
                success(false, response)
            }
        }
    }
    
    //MARK: Update Shipping Address Api
    static func updateShippingAddressApi(params: Parameters,success:@escaping (_ success: Bool,_ response: APIResponse) -> Void ) {
        APIManager.shared.putRequest(url: APIEndPoint.updateAddress.rawValue, parameters: params) { (response) in
            let status = response.response["status"]
            if status == "200" {
                success(true, response)
            }else {
                success(false, response)
            }
        }
    }
    
    //MARK: Static Content Api With Type
    static func staticContentApi(parameters: Parameters, success:@escaping (_ success: Bool,_ response: APIResponse) -> Void) {
        APIManager.shared.getMethodWithoutAuth(method: .get, url: APIEndPoint.staticContentApi.rawValue, parameters: parameters) { (response) in
            let status = response.response["status"]
            if status == "200" {
                success(true, response)
            }else {
                success(false, response)
            }
        }
    }
    
    //MARK: Delete Address Api
    static func deleteAddressAPI(parameters: Parameters , success:@escaping (_ success: Bool,_ response: APIResponse) -> Void) {
        APIManager.shared.request2(method: .delete, url: APIEndPoint.deleteAddress.rawValue, parameters: parameters) { (response) in
            let status = response.response["status"]
            if status == "200" {
                success(true, response)
            }else {
                success(false, response)
            }
        }
    }
    
    //MARK: Clear Cart Item Api
    static func clearCartItemApi(urlParameters: Parameters, bodyParameter:Parameters, success:@escaping (_ success: Bool,_ response: APIResponse) -> Void ){
        APIManager.shared.mainRequest(method: .delete, url: APIEndPoint.clearCartItemApi.rawValue, urlParameters: urlParameters, bodyParameter: bodyParameter, needUserToken: true) { (response) in
            let status = response.response["status"]
            if status == "200" {
                success(true, response)
            }else {
                success(false, response)
            }
        }
    }
    
    //MARK: Post Order Notes Api
    static func postOrderNoteApi(urlParameters: Parameters, bodyParameter:Parameters, success:@escaping (_ success: Bool,_ response: APIResponse) -> Void ) {
        APIManager.shared.mainRequest(method: .post, url: APIEndPoint.postOrderNoteApi.rawValue, urlParameters: urlParameters, bodyParameter: bodyParameter, needUserToken: true) { (response) in
            let status = response.response["status"]
            if status == "200" {
                success(true, response)
            }else {
                success(false, response)
            }
        }
    }
    
    //MARK: Dispute List Api
    static func disputeListApi(urlParameters: Parameters, bodyParameter:Parameters, success:@escaping (_ success: Bool,_ response: APIResponse) -> Void) {
        APIManager.shared.mainRequest(method: .post,url: APIEndPoint.disputeListApi.rawValue, urlParameters: urlParameters, bodyParameter: bodyParameter, needUserToken: true) { (response) in
            let status = response.response["status"]
            if status == "200" {
                success(true, response)
            }else {
                success(false, response)
            }
        }
    }
    
    //MARK: Dispute List Api
    static func sendMessageAPI(urlParameters: Parameters = [:], bodyParameter:Parameters, success:@escaping (_ success: Bool,_ response: APIResponse) -> Void) {
        APIManager.shared.mainRequest(method: .post,url: APIEndPoint.send_message.rawValue, urlParameters: urlParameters, bodyParameter: bodyParameter, needUserToken: true) { (response) in
            let status = response.response["status"]
            if status == "200" {
                success(true, response)
            }else {
                success(false, response)
            }
        }
    }
    
    // MARK: FAQ Api
    static func disputeDetailsApi(id: String, success:@escaping (_ success: Bool,_ response: APIResponse) -> Void) {
        APIManager.shared.getMethod(method: .get, url: APIEndPoint.disputeDetailsApi.rawValue+"/\(id)") { (response) in
            let status = response.response["status"]
            if status == "200" {
                success(true, response)
            }else {
                success(false, response)
            }
        }
    }
    
    //MARK: Add Money To Wallet Api
    static func addMoneyToWalletApi(bodyParameter: Parameters , success:@escaping (_ success: Bool,_ response: APIResponse) -> Void){
        APIManager.shared.mainRequest(method: .post, url: APIEndPoint.addMoneyToWalletApi.rawValue, bodyParameter: bodyParameter, needUserToken: true) { (response) in
            let status = response.response["status"]
            if status == "200" {
                success(true, response)
            }else {
                success(false, response)
            }
        }
    }
    
    // MARK: Transfer Money To Wallet Api
    static func transferMoneyToWalletApi(bodyParameter: Parameters , success:@escaping (_ success: Bool,_ response: APIResponse) -> Void){
        APIManager.shared.mainRequest(method: .post, url: APIEndPoint.transferMoneyToWalletApi.rawValue, bodyParameter: bodyParameter, needUserToken: true) { (response) in
            let status = response.response["status"]
            if status == "200" {
                success(true, response)
            }else {
                success(false, response)
            }
        }
    }
    
    //MARK: Get All Order List Api
    static func walletTranscationApi( urlParameters: Parameters, bodyParameter:Parameters,success:@escaping (_ success: Bool,_ response: APIResponse) -> Void) {
        APIManager.shared.mainRequest(method: .post, url: APIEndPoint.walletTranscationApi.rawValue, urlParameters: urlParameters, bodyParameter: bodyParameter, needUserToken: true) { (response) in
            let status = response.response["status"]
            if status == "200" {
                success(true, response)
            }else {
                success(false, response)
            }
        }
    }
    
    //MARK: View Wallet Balance By Id Api
    static func viewWalletBalanceByIdApi(parameters: Parameters,userId: String, success:@escaping (_ success: Bool,_ response: APIResponse) -> Void) {
        APIManager.shared.getMethod(method: .get, url: APIEndPoint.viewWalletBalanceByIdApi.rawValue + "\(userId)/balance", parameters: parameters) { (response) in
            let status = response.response["status"]
            if status == "200" {
                success(true, response)
            }else {
                success(false, response)
            }
        }
    }
    
}


