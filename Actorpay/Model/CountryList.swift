//
//  CountryList.swift
//  Actorpay
//
//  Created by iMac on 07/01/22.
//

import Foundation
import SwiftyJSON

struct CountryList {
    
    let id : String?
    let active : Bool?
    let country : String?
    let countryCode : String?
    let countryFlag : String?
    let defaultCountry : Bool?
    
    init(json: JSON) {
       
        id = json["id"].string
        active = json["active"].bool
        country = json["country"].string
        countryCode = json["countryCode"].string
        countryFlag = json["countryFlag"].string
        defaultCountry = json["default"].bool
        
    }
}

struct Countries {
    var letter: String?
    var countries: [CountryList]?
    
    init(letter: String? , countries: [CountryList]) {
        self.letter = letter
        self.countries = countries
    }
}
