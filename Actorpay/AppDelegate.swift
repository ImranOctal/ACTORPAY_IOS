//
//  AppDelegate.swift
//  Actorpay
//
//  Created by iMac on 01/12/21.
//

import UIKit
import IQKeyboardManagerSwift
import AKSideMenu
import UserNotifications
import GoogleSignIn
import FBSDKCoreKit
import GoogleMaps
import GooglePlaces

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    let googleClientId = "450644605577-1ejahodv9ehqr33aombp1qncrnp0ni8i.apps.googleusercontent.com"
    let google_map_key = "AIzaSyDhMau_8Eah9KaloP_NWaBhDjvryMlzcD0"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
//        let settings: UNAuthorizationOptions = [.alert, .badge, .sound]
//        UNUserNotificationCenter.current().requestAuthorization(options: settings) { (accepted, error) in
//            print(error?.localizedDescription ?? "")
//            print(accepted)
//        }
        self.registerForPushNotifications()
        AppManager.shared.countryName = "India"
        AppManager.shared.countryCode = "+ 91"
        AppManager.shared.countryFlag = "IN"

        GMSPlacesClient.provideAPIKey(google_map_key)
        GMSServices.provideAPIKey(google_map_key)
        _ = GIDConfiguration.init(clientID: googleClientId)
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if error != nil || user == nil {
                // Show the app's signed-out state.
            } else {
                // Show the app's signed-in state.
            }
        }
        
        FBSDKCoreKit.ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        Settings.shared.appID = "473779207383239"
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
    
}

//MARK: - Extensions -

extension AppDelegate {
    // SetUp Navigation Flow
    func setupNavigation(){
        if (AppManager.shared.token.count > 0){
            print(AppManager.shared.token)
            let newVC = self.storyBoard.instantiateViewController(withIdentifier: "HomeNav") as! UINavigationController
            myApp.window?.rootViewController = newVC
        }else{
            if !UserDefaults.standard.bool(forKey: "introShow"){
                UserDefaults.standard.setValue(true, forKey: "introShow")
                UserDefaults.standard.synchronize()
                let newVC = self.storyBoard.instantiateViewController(withIdentifier: "introNav") as! UINavigationController
                myApp.window?.rootViewController = newVC
            } else {
                let newVC = self.storyBoard.instantiateViewController(withIdentifier: "loginVC") as! UINavigationController
                myApp.window?.rootViewController = newVC
            }
            
        }
    }
}

//MARK: User Notification Center Delegate Methods
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        deviceFcmToken = tokenParts.joined()
        print("deviceToken:-\(deviceFcmToken ?? "")")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error.localizedDescription)
    }
    
}


//MARK: - Google Sign In Flow -
extension AppDelegate {
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        var signedIn: Bool = GIDSignIn.sharedInstance.handle(url)
        
        signedIn = signedIn ? signedIn : ApplicationDelegate.shared.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        
        return signedIn
    }
    
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        let signedIn: Bool = GIDSignIn.sharedInstance.handle(url)
        ApplicationDelegate.shared.application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: nil)
        
        return signedIn
    }    
}

extension AppDelegate {
    // MARK: Register app for push notificaitons
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            [weak self] granted, error in
            print("Permission granted: \(granted)")
            isNotificationEnabled = granted
            if error == nil {
                self?.getNotificationSettings()
            }
            
        }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("Notification settings: \(settings)")
            switch settings.authorizationStatus {
            case .authorized:
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
                isNotificationEnabled = true
            case .denied:
                print("Notifications Denied")
                isNotificationEnabled = false
            case .notDetermined:
                print("Notifications not determined")
            default:
                break
            }            
        }
    }
}
