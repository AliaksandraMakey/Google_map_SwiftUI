//
//  CustomButton.swift
//  Google_map_SwiftUI
//
//  Created by Александра Макей on 17.11.2023.
//

import UIKit

class RoundedButton: UIButton {
    //MARK: - Life cicle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    //MARK: - Metods
    private func setupButton() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 8 
        self.backgroundColor = UIColor.blue
        self.setTitleColor(UIColor.white, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 16)
    }
}
