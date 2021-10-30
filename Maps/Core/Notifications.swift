//
//  Notifications.swift
//  Maps
//
//  Created by Alexander Kolomenskiy on 28.10.2021.
//

import UIKit
import UserNotifications

class Notifications: NSObject, UNUserNotificationCenterDelegate {

    let notificationIdentifire = "Maps Notification"
    let notifaicationType = "Local Notification"
    let notificationAfterMinutsInterval: Double = 30

    let notificationCenter = UNUserNotificationCenter.current()

    func requestAutorization() {
        notificationCenter.requestAuthorization(options: [.sound ]) { (granted, error) in
            print("Permission granted: \(granted)")

            guard granted else { return }
            self.getNotificationSettings()
        }
    }

    func getNotificationSettings() {
        notificationCenter.getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
        }
    }

    func scheduleNotification() {

        let content = UNMutableNotificationContent()

        let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? ""
        content.title = notificationIdentifire
        content.body = "Please go back to application \(appName)"
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: (notificationAfterMinutsInterval * 60), repeats: false)

        let identifire = notifaicationType
        let request = UNNotificationRequest(identifier: identifire,
                                            content: content,
                                            trigger: trigger)

        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }

    }


}
