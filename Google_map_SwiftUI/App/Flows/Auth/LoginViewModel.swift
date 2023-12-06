//
//  LoginViewModel.swift
//  Google_map_SwiftUI
//
//  Created by Александра Макей on 04.12.2023.
//

import SwiftUI

class LoginViewModel: ObservableObject {
    //MARK: - Properties
    @Published var login: String = ""
    @Published var password: String = ""
    @Published var isAuthorized: Bool = false
    //MARK: - Metods
    func authorize() {
        isAuthorized = UserManager.instance.authorize(login: login, password: password)
    }
}
