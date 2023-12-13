//
//  Notifications.swift
//  Google_map_SwiftUI
//
//  Created by Александра Макей on 13.12.2023.
//

import UIKit
import UserNotifications

class Notifications: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    let notificationIdentifier = "MapsNotification"
    let notificationType = "LocalNotification"
    let notificationAfterMinutesInterval: Double = 1

    let notificationCenter = UNUserNotificationCenter.current()

    func requestAuthorization() {
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
        content.title = notificationIdentifier
        content.body = "Please go back to the \(appName) application"
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: (notificationAfterMinutesInterval * 60), repeats: false)

        let identifier = notificationType
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content,
                                            trigger: trigger)

        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
    }
}
