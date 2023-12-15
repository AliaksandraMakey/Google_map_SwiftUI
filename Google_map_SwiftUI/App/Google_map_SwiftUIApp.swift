//
//  Google_map_SwiftUIApp.swift
//  Google_map_SwiftUI
//
//  Created by Александра Макей on 15.11.2023.
//

import SwiftUI
import GoogleMaps
import RealmSwift
import UserNotifications

@main
struct Google_map_SwiftUIApp: SwiftUI.App {
    let notifications = NotificationManager()
    init() {
        GMSServices.provideAPIKey("key")
#if DEBUG
        print(Realm.Configuration.defaultConfiguration.fileURL ?? "Realm eror")
#endif
        notifications.requestAuthorization()
        notifications.notificationCenter.delegate = notifications
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(notifications)
        }
    }
}


