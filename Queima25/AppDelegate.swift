//
//  AppDelegate.swift
//  Queima25
//
//  Created by João Morais on 02/05/2025.
//

import UIKit
import SpriteKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Create window manually
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = UIColor(red: 0.12, green: 0.12, blue: 0.2, alpha: 1.0) // Modern app background color
        
        // Create and set root view controller
        let gameVC = GameViewController()
        window.rootViewController = gameVC
        
        // Store and show window
        self.window = window
        window.makeKeyAndVisible()
        
        print("AppDelegate: Window created and displayed with GameViewController")
        
        return true
    }
    
    // Comment out scene delegate methods to disable scene-based lifecycle
    /*
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    */
}
