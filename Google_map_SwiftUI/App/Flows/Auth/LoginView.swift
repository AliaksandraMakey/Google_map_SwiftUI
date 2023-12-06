//
//  LoginView.swift
//  Google_map_SwiftUI
//
//  Created by Александра Макей on 04.12.2023.
//

import SwiftUI

struct LoginView: View {
    //MARK: - Properties
    @StateObject var viewModel = LoginViewModel()
    var alerts = Alerts()
    //MARK: - Show view
    @State private var showAlert = false
    @State private var showMainView = false
    @State private var showForgotPasswordView = false
    @State private var showRegisterView = false
    
    var body: some View {
        VStack(spacing: 16) {
            TextField("Login", text: $viewModel.login)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            SecureField("Password", text: $viewModel.password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Spacer().frame(height: 20)
            Button("Login") {
                viewModel.authorize()
                if viewModel.isAuthorized {
                    self.showMainView.toggle()
                } else {
                    self.showAlert.toggle()
                }
            }
            Button("Forgot password?") {
                self.showForgotPasswordView.toggle()
            }
            Button("Register") {
                self.showRegisterView.toggle()
            }
        }
        .padding()
        //MARK: - Presenters
        .alert(isPresented: $showAlert) {
            self.alerts.showErrorAuthAlert()
        }
        .fullScreenCover(isPresented: $showMainView, content: {
            MainView()
        })
        .sheet(isPresented: $showForgotPasswordView) {
            ForgotPasswordView()
        }
        .sheet(isPresented: $showRegisterView) {
            RegisterView()
        }
    }
}
