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
        @State private var selectedImage: UIImage?
    //MARK: - Show view
    @State private var showMapView = false
    @State private var showLoginView = false
    @State private var showEditPhotoView = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                Text("Hello \(loginName ?? "")")
                
                Button("Show Map") {
                    self.showMapView.toggle()
                }
                Button("Logout") {
                    UserManager.instance.logout()
                    self.showLoginView.toggle()
                }
                Button("Selfi") {
                    self.showEditPhotoView.toggle()
                }
            }
            .padding()
            .navigationTitle("Main View")
            //MARK: - Presenters
            .fullScreenCover(isPresented: $showLoginView, content: {
                LoginView()
            })
            .fullScreenCover(isPresented: $showMapView, content: {
                NavigationView {
                    MapView(mapViewModel: MapViewModel())
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .navigationBarTitle("Map", displayMode: .inline)
                        .navigationBarItems(trailing: Button("Close") {
                            showMapView.toggle()
                        })
                }
            })
            .fullScreenCover(isPresented: $showEditPhotoView, content: {
                NavigationView {
                    EditPhotoView(image: $selectedImage)
                }
            })
        }
    }
}

