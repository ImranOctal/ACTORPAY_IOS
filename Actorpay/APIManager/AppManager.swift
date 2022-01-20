//
//  AppManager.swift
//  Actorpay
//
//  Created by iMac on 20/12/21.
//

import Foundation
import SwiftyJSON

class AppManager {
  
    static let shared = AppManager()
    
    var token: String {
        get {
            let token =  AppUserDefaults.getSavedObject(forKey: .userAuthToken) as? String
            return token ?? ""
        }
        set(newToken) {
            AppUserDefaults.saveObject(newToken, forKey: .userAuthToken)
        }
    }
    
    var userId: String {
        get {
            let userId =  AppUserDefaults.getSavedObject(forKey: .activeUserId) as? String
            return userId ?? ""
        }
        set(userId) {
            AppUserDefaults.saveObject(userId, forKey: .activeUserId)
        }
    }
    
    var rememberMeEmail: String {
        get {
            let rememberMeEmail =  AppUserDefaults.getSavedObject(forKey: .rememberMeEmail) as? String
            return rememberMeEmail ?? ""
        }
        set(rememberMeEmail) {
            AppUserDefaults.saveObject(rememberMeEmail, forKey: .rememberMeEmail)
        }
    }
    
    var rememberMePassword: String {
        get {
            let rememberMePassword =  AppUserDefaults.getSavedObject(forKey: .rememberMePassword) as? String
            return rememberMePassword ?? ""
        }
        set(rememberMePassword) {
            AppUserDefaults.saveObject(rememberMePassword, forKey: .rememberMePassword)
        }
    }
    
    var countryName: String {
        get {
            let countryName =  AppUserDefaults.getSavedObject(forKey: .countryName) as? String
            return countryName ?? ""
        }
        set(countryName) {
            AppUserDefaults.saveObject(countryName, forKey: .countryName)
        }
    }
    
    var countryFlag: String {
        get {
            let countryFlag =  AppUserDefaults.getSavedObject(forKey: .countryFlag) as? String
            return countryFlag ?? ""
        }
        set(countryFlag) {
            AppUserDefaults.saveObject(countryFlag, forKey: .countryFlag)
        }
    }
    
    var countryCode: String {
        get {
            let countryCode =  AppUserDefaults.getSavedObject(forKey: .countryCode) as? String
            return countryCode ?? ""
        }
        set(countryCode) {
            AppUserDefaults.saveObject(countryCode, forKey: .countryCode)
        }
    }
    
}

class AppUserDefaults {
    class func saveObject(_ object: Any?, forKey key: UserDefaultsConstant) {
        let defaults = UserDefaults.standard
        defaults.set(object, forKey: key.rawValue)
        defaults.synchronize()
    }

    class func getSavedObject(forKey: UserDefaultsConstant) -> Any? {
        let savedObject = UserDefaults.standard.object(forKey: forKey.rawValue)
        return savedObject
    }
}

enum UserDefaultsConstant: String {
    case userAuthToken = "keyAcccessToken"
    case activeUserId = "activeUserId"
    case rememberMeEmail = "rememberMeEmail"
    case rememberMePassword = "rememberMePassword"
    case countryCode = "countryCode"
    case countryName = "countryName"
    case countryFlag = "countryFlag"
}
