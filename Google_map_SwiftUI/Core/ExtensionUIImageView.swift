//
//  ExtensionUIImageView.swift
//  Google_map_SwiftUI
//
//  Created by Александра Макей on 15.12.2023.
//

import UIKit

extension UIImageView {
    func rounded() {
        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.blue.cgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}
