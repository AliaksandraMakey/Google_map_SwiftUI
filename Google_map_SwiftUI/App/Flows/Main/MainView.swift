//
//  MainView.swift
//  Google_map_SwiftUI
//
//  Created by Александра Макей on 04.12.2023.
//

import SwiftUI

struct MainView: View {
    //MARK: - Properties
    var loginName: String?
    //MARK: - Show view
    @State private var showMapView = false
    @State private var showLoginView = false
    
    var body: some View {
        VStack {
            Text("Hello \(loginName ?? "")")
                .padding()
            
            Button("Show Map") {
                self.showMapView.toggle()
            }
            .padding()
            
            Button("Logout") {
                UserManager.instance.logout()
                self.showLoginView.toggle()
            }
            .padding()
        }
        //MARK: - Presenters
        .fullScreenCover(isPresented: $showLoginView, content: {
            LoginView()
        })
        .fullScreenCover(isPresented: $showMapView, content: {
            Spacer(minLength: 20)
            
            MapView(mapViewModel: MapViewModel())
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 40)
                .padding(.vertical, 20)
            
            Spacer(minLength: 30)
        })
    }
}
