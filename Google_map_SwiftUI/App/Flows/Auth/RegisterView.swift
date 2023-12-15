//
//  RegisterView.swift
//  Google_map_SwiftUI
//
//  Created by Александра Макей on 06.12.2023.
//

import SwiftUI

struct RegisterView: View {
    //MARK: - Properties
    @State private var loginName: String = ""
    @State private var password: String = ""
    var alerts = Alerts()
    @ObservedObject var appStateManager = AppStateManager()
    var isLoginValid: Bool {
        return loginName.count >= 3 && password.count >= 6
    }
    //MARK: - Show view
    @State private var showAlert = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                TextField("Username", text: $loginName)
                    .disableAutocorrection(true)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                SecureField("Password", text: $password)
                    .disableAutocorrection(true)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button("Register") {
                    UserManager.instance.saveUser(login: loginName, password: password)
                    self.showAlert.toggle()
                }
                .disabled(!isLoginValid)
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
            self.alerts.registerSuccessAlert(login: loginName)
        }
    }
}
//#Preview {
//    RegisterView()
//}
