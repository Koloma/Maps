//
//  AppDelegate.swift
//  Maps
//
//  Created by Коломенский Александр on 06.10.2021.
//

import UIKit
import GoogleMaps
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let notifications = Notifications()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        GMSServices.provideAPIKey("AIzaSyA97ysHp32tXw3ZZyfdQkJL1ub2kvbDGY8")
#if DEBUG
            print(Realm.Configuration.defaultConfiguration.fileURL ?? "Realm error")
#endif

        notifications.requestAutorization()
        notifications.notificationCenter.delegate = notifications
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
}
