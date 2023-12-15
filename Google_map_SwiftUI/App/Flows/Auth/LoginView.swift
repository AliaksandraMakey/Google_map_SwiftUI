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
    var isLoginValid: Bool {
        return viewModel.login.count >= 3 && viewModel.password.count >= 6
    }
    var alert = Alerts()
    //MARK: - Show view
    @State private var showAlert = false
    @State private var showMainView = false
    @State private var showForgotPasswordView = false
    @State private var showRegisterView = false

    var body: some View {
        VStack(spacing: 16) {
            TextField("Login", text: $viewModel.login)
                .disableAutocorrection(true) 
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            SecureField("Password", text: $viewModel.password)
                .disableAutocorrection(true)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Spacer().frame(height: 20)
            Button("Log in") {
                viewModel.authorize()
                if viewModel.isAuthorized {
                    self.showMainView.toggle()
                } else {
                    self.showAlert.toggle()
                }
            }
            .disabled(!isLoginValid)
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
                self.alert.showErrorAuthAlert()
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
