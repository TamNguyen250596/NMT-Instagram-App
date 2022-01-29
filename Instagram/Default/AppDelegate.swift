//
//  AppDelegate.swift
//  Instagram
//
//  Created by Nguyen Minh Tam on 03/01/2022.
//

import UIKit
import Firebase
import UserNotifications
import GoogleSignIn
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    //MARK: Properties
    var window: UIWindow?
    
    //MARK: App cycle
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = TabBarViewController()
        window?.makeKeyAndVisible()
        
        FBSDKCoreKit.ApplicationDelegate.shared.application(
                    application,
                    didFinishLaunchingWithOptions: launchOptions)
        
        return true
    }
    
    //MARK: Helpers
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any])
      -> Bool {
     GIDSignIn.sharedInstance.handle(url)
          
    ApplicationDelegate.shared.application(application, open: url,
    sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
    annotation: options[UIApplication.OpenURLOptionsKey.annotation])
              
    return true
    }
}

