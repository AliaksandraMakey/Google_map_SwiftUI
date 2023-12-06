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
    //MARK: - Show view
    @State private var showAlert = false
    
       var body: some View {
        VStack {
            TextField("Login", text: .constant(viewModel.login))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Show password") {
                self.showAlert.toggle()
            }
            .padding()
        }
        //MARK: - Presenters
        .alert(isPresented: $showAlert) {
            Alerts().showPasswordAlert(login: viewModel.login)
        }
    }
}
