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
        
        let centralManagerVC = storyboard.instantiateViewController(withIdentifier: "CentralManagerViewController") as! CentralManagerViewController
        let peripheralManagerVC = storyboard.instantiateViewController(withIdentifier: "PeripheralManagerViewController") as! PeripheralManagerViewController
        
        let tabBarVC = UITabBarController()
        tabBarVC.tabBar.isHidden = true
        tabBarVC.viewControllers = [centralManagerVC, peripheralManagerVC]
        
        self.window?.rootViewController = tabBarVC

        self.window?.makeKeyAndVisible()
        
        return true
    }
}

