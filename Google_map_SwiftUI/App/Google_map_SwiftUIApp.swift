//
//  Google_map_SwiftUIApp.swift
//  Google_map_SwiftUI
//
//  Created by Александра Макей on 15.11.2023.
//

import SwiftUI
import GoogleMaps
import RealmSwift

@main
struct Google_map_SwiftUIApp: SwiftUI.App {
    init() {
        GMSServices.provideAPIKey("AIzaSyBWtKY9fFUzDyBKR5U0HTjT7JEB3mJIeKQ")
#if DEBUG
        print(Realm.Configuration.defaultConfiguration.fileURL ?? "Realm eror")
#endif
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

