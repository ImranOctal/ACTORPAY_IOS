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
    
    static func updateUser(params: Parameters,success:@escaping (_ success: Bool,_ response: APIResponse) -> Void ){
        APIManager.shared.request2(method: .put, url: APIEndPoint.userUpdate.rawValue, parameters: params) { (response) in
            let status = response.response["status"]
            if status == "200" {
                success(true, response)
            }else {
                success(false, response)
            }
        }
    }
    
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
    
    //MARK: - GET METHOD API -
    
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
    
}
