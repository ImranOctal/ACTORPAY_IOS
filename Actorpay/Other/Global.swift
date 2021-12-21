//
//  Global.swift
//  Actorpay
//
//  Created by iMac on 01/12/21.
//

import Foundation
import UIKit

let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
let myApp = UIApplication.shared.delegate as! AppDelegate
let token = ""
typealias typeAliasStringDictionary         = [String: String]
var selectedTabIndex = 0
var selectedTabTag = 1001
let VAL_TITLE                               = "Val_TITLE"
let VAL_IMAGE                               = "VAL_IMAGE"
var primaryColor = UIColor.init(hexFromString: "#183967")

func startActivityIndicator(shouldCenter: Bool = true) {
    DispatchQueue.main.async {
        let yPosition: CGFloat = shouldCenter ? (UIScreen.main.bounds.height/2) : 0
            let activityView = UIActivityIndicatorView(style: .whiteLarge)
            activityView.color = UIColor.black
            activityView.center = CGPoint(x: UIScreen.main.bounds.width/2, y: yPosition)
        myApp.window?.rootViewController?.view.addSubview(activityView)
            activityView.startAnimating()
        
    }
}

func stopActivityIndicator() {
    if let activityViews = myApp.window?.rootViewController?.view.subviews.filter({ $0 is UIActivityIndicatorView }) as? [UIActivityIndicatorView] {
        DispatchQueue.main.async {
            activityViews.forEach { (loader) in
                loader.stopAnimating()
                loader.removeFromSuperview()
            }
        }
    }
}

func attributedString(countryCode: String, arrow : String) -> NSMutableAttributedString {
    let countryCodeAttr = [ NSAttributedString.Key.foregroundColor: UIColor.black ]
    let countryCodeAttrString = NSAttributedString(string: countryCode, attributes: countryCodeAttr)
    
    let arrowAttr = [ NSAttributedString.Key.foregroundColor: UIColor.darkGray ]
    let arrowAttrString = NSAttributedString(string: arrow, attributes: arrowAttr)
    
    let mutableAttributedString = NSMutableAttributedString()
    mutableAttributedString.append(countryCodeAttrString)
    mutableAttributedString.append(arrowAttrString)
    return mutableAttributedString
}

func topCorner(bgView:UIView, maskToBounds: Bool) {
    bgView.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
    bgView.layer.shadowOffset = CGSize(width: -1, height: -2)
    bgView.layer.shadowRadius = 2
    bgView.layer.shadowOpacity = 0.1
    bgView.layer.cornerRadius = 50
    bgView.layer.masksToBounds = maskToBounds
 }

func topCorners(bgView:UIView, cornerRadius: CGFloat ,maskToBounds: Bool) {
    bgView.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
//    bgView.layer.shadowOffset = CGSize(width: -1, height: -2)
//    bgView.layer.shadowRadius = 2
//    bgView.layer.shadowOpacity = 0.1
    bgView.layer.cornerRadius = cornerRadius
    bgView.layer.masksToBounds = maskToBounds
 }

func bottomCorner(bgView:UIView, cornerRadius: CGFloat ,maskToBounds: Bool) {
    bgView.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
//    bgView.layer.shadowOffset = CGSize(width: -1, height: -2)
//    bgView.layer.shadowRadius = 2
//    bgView.layer.shadowOpacity = 0.1
    bgView.layer.cornerRadius = cornerRadius
    bgView.layer.masksToBounds = maskToBounds
 }

struct ScreenSize
{
   static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
   static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
   static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
   static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

