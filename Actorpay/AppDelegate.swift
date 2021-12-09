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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
//        showHomePage()
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

//    func showHomePage(){
//        let contentViewController = HomeViewController(nibName: "HomeViewController", bundle: nil)
//        var homeNavigationController: UINavigationController!
//        homeNavigationController = UINavigationController.init(rootViewController: contentViewController)
//        let menuViewController = SideMenuViewController(nibName: "SideMenuViewController", bundle: nil)
//        
//            // Create side menu controller
//        let sideMenuViewController: AKSideMenu = AKSideMenu(contentViewController: homeNavigationController, leftMenuViewController: menuViewController, rightMenuViewController: UIViewController())
//        window?.rootViewController = sideMenuViewController
//        window?.backgroundColor = UIColor.white
//        window?.makeKeyAndVisible()
//    }
    
}

