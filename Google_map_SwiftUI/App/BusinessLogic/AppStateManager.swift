//
//  AppStateManager.swift
//  Google_map_SwiftUI
//
//  Created by Александра Макей on 06.12.2023.
//

import SwiftUI

class AppStateManager: ObservableObject {
    @Published var isBlurred = false

    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func willResignActive() {
        isBlurred = true
    }

    @objc private func didBecomeActive() {
        isBlurred = false
    }
}
