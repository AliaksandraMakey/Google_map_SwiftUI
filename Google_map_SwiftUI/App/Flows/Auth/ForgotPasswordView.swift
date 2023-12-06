//
//  ForgotPasswordView.swift
//  Google_map_SwiftUI
//
//  Created by Александра Макей on 04.12.2023.
//


import SwiftUI

struct ForgotPasswordView: View {
    //MARK: - Properties
    @StateObject var viewModel = LoginViewModel()
    @ObservedObject var appStateManager = AppStateManager()
    //MARK: - Show view
    @State private var showAlert = false
    
       var body: some View {
        ZStack {
            VStack(spacing: 16) {
                TextField("Login", text: .constant(viewModel.login))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button("Show password") {
                    self.showAlert.toggle()
                }
            }
            .padding()
            //MARK: - Blur Effect
            if appStateManager.isBlurred {
                VisualEffectView(style: .extraLight)
                    .edgesIgnoringSafeArea(.all)
            }
        }
        //MARK: - Presenters
        .alert(isPresented: $showAlert) {
            Alerts().showPasswordAlert(login: viewModel.login)
        }
    }
}
