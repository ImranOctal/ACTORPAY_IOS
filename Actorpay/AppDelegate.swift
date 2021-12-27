//
//  AppDelegate.swift
//  Actorpay
//
//  Created by iMac on 01/12/21.
//

import UIKit
import IQKeyboardManagerSwift
import AKSideMenu

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        return true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func setupNavigation(){
        if (AppManager.shared.token.count > 0){
            let newVC = self.storyBoard.instantiateViewController(withIdentifier: "HomeNav") as! UINavigationController
            myApp.window?.rootViewController = newVC
        }else{
            let newVC = self.storyBoard.instantiateViewController(withIdentifier: "loginVC") as! UINavigationController
            myApp.window?.rootViewController = newVC
        }
    }
    
}
