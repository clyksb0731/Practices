//
//  AppDelegate.swift
//  BLEPractice
//
//  Created by Yongseok Choi on 2021/11/28.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let initialVC = storyboard.instantiateViewController(withIdentifier: "InitialViewController") as! InitialViewController
        
        self.window?.rootViewController = initialVC

        self.window?.makeKeyAndVisible()
        
        return true
    }
}

