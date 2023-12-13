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
        NavigationView {
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
        }
    }
}

//struct MainView: View {
//    //MARK: - Properties
//    var loginName: String?
//    //MARK: - Show view
//    @State private var showMapView = false
//    @State private var showLoginView = false
//    
//    var body: some View {
//        VStack {
//            Text("Hello \(loginName ?? "")")
//                .padding()
//            
//            Button("Show Map") {
//                self.showMapView.toggle()
//            }
//            .padding()
//            
//            Button("Logout") {
//                UserManager.instance.logout()
//                self.showLoginView.toggle()
//            }
//            .padding()
//        }
//        //MARK: - Presenters
//        .fullScreenCover(isPresented: $showLoginView, content: {
//            LoginView()
//        })
//        .fullScreenCover(isPresented: $showMapView, content: {
//            Spacer(minLength: 20)
//            
//            MapView(mapViewModel: MapViewModel())
//                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 40)
//                .padding(.vertical, 20)
//            
//            Spacer(minLength: 30)
//        })
//    }
//}
