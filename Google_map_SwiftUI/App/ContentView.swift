//
//  ContentView.swift
//  Google_map_SwiftUI
//
//  Created by Александра Макей on 15.11.2023.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var appStateManager = AppStateManager()
    
    var body: some View {
        ZStack {
            LoginView()
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

