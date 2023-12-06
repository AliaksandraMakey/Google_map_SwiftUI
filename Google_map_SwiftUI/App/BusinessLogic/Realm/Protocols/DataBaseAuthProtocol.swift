//
//  DataBaseAuthProtocol.swift
//  Google_map_SwiftUI
//
//  Created by Александра Макей on 06.12.2023.
//

import Foundation

protocol DataBaseAuthProtocol {

    func loadUser(login: String) -> User?
    func saveUser(user: User)
    func deleteUser(login: String)
}
