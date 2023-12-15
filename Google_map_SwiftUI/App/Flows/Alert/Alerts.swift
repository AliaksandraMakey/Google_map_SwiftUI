//
//  Alerts.swift
//  Google_map_SwiftUI
//
//  Created by Александра Макей on 04.12.2023.
//


import SwiftUI

struct Alerts {
    static func showAlert(title: String, message: String, actions: [Alert.Button]) -> Alert {
        return Alert(title: Text(title), message: Text(message), primaryButton: actions[0], secondaryButton: actions[1])
    }
    
    func showErrorAuthAlert() -> Alert {
        let continueWithoutLoginAction = Alert.Button.default(Text("Continue without login")) {
            //TODO: - обработать переходы
        }
        
        let okAction = Alert.Button.default(Text("OK")) {
            //TODO: - обработать переходы
        }
        
        return Alerts.showAlert(
            title: "Authorization Failed",
            message: "Please login first.",
            actions: [continueWithoutLoginAction, okAction]
        )
    }
    func showPasswordAlert(login: String) -> Alert {
        if let user = UserManager.instance.loadUser(login: login) {
            let alert = Alert(title: Text("Password"),
                              message:  Text(user.password),
                              dismissButton: .default(Text("OK")))
            return alert
        }
        return Alert(title: Text("Failed load"))
    }
    func registerSuccessAlert(login: String) -> Alert {
        let alert = Alert(title: Text("Successful registration"),
                          message: Text("User \(login) registered successfully"), dismissButton: .default(Text("OK")))
        return alert
    }
    func showCameraNotAvailable() -> Alert {
        let alert = Alert(title: Text("Camera is not available"),
                          message: Text("Please use your photo library"),
                          dismissButton: .default(Text("OK")))
        return alert
    }
}
