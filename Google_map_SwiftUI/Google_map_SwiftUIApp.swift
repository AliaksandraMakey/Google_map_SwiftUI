//
//  Google_map_SwiftUIApp.swift
//  Google_map_SwiftUI
//
//  Created by Александра Макей on 15.11.2023.
//

import SwiftUI
import GoogleMaps

@main
struct Google_map_SwiftUIApp: App {
    init() {
        GMSServices.provideAPIKey("AIzaSyArENEA_Kq4mfbHeb5GyPlZPFnkYmglxXU")
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
