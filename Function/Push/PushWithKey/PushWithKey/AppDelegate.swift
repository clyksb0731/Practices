//
//  AppDelegate.swift
//  PushWithKey
//
//  Created by Yongseok Choi on 2022/05/28.
//

import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var bgTaskID: UIBackgroundTaskIdentifier = .invalid

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            //
        }
        
        UNUserNotificationCenter.current().delegate = self
        
        application.registerForRemoteNotifications()
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        if bgTaskID != .invalid {
            DispatchQueue.global().async {
                UIApplication.shared.endBackgroundTask(self.bgTaskID)
                self.bgTaskID = .invalid
            }
        }
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("applicationDidEnterBackground")
        if self.bgTaskID == .invalid {
            self.bgTaskID = UIApplication.shared.beginBackgroundTask {
                print("App will be terminated soon")
                UIApplication.shared.endBackgroundTask(self.bgTaskID)
                self.bgTaskID = .invalid
            }
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        print("UserInfo: \(userInfo) at background push")
        
        completionHandler(.noData)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
                
        print("APNs device token: \(deviceTokenString)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Error: \(error.localizedDescription)")
    }
}

// MARK: - Extension for UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // 앱이 포그라운일 때
        // 자동으로 호출 됨
        
        let userInfo = notification.request.content.userInfo
        
        print("UserInfo: \(userInfo) at willPresent\n")
        
        completionHandler([.sound, .banner])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // 백그라운드일 때 오는 노티 알림을 노티를 터치할 때 호출 됨
        
        let userInfo = response.notification.request.content.userInfo
        
        print("UserInfo: \(userInfo) at didReceive\n")
        
        completionHandler()
    }
}
