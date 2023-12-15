//
//  ContentView.swift
//  Google_map_SwiftUI
//
//  Created by Александра Макей on 15.11.2023.
//

import SwiftUI

struct ContentView: View {
    //MARK: - Properties
    @ObservedObject var appStateManager = AppStateManager()
    @EnvironmentObject var notifications: NotificationManager
    
    var body: some View {
        ZStack {
            LoginView()
                .onAppear {
                    notifications.scheduleNotification()
                }
            //MARK: - Blur Effect
            if appStateManager.isBlurred {
                VisualEffectView(style: .extraLight)
                    .edgesIgnoringSafeArea(.all)
            }
        }

    }
}

//#Preview {
//    ContentView()
//}

