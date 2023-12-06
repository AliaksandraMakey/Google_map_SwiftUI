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
//    @State private var isRegistered: Bool = false
    var alerts = Alerts()
    //MARK: - Show view
    @State private var showAlert = false
    
    var body: some View {
        VStack {
            TextField("Username", text: $loginName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
              
            Button("Register") {
                UserManager.instance.saveUser(login: loginName, password: password)
                self.showAlert.toggle()
//                isRegistered = true
            }
            .disabled(loginName.isEmpty || password.isEmpty)
        }
        .padding()
        //MARK: - Presenters
        .alert(isPresented: $showAlert) {
            self.alerts.registerSuccessAlert(login: loginName)
        }
        .padding()
    }
}

//    struct RegisterView_Previews: PreviewProvider {
//        static var previews: some View {
//            RegisterView()
//        }
//    }
