//
//  CustomButton.swift
//  Google_map_SwiftUI
//
//  Created by Александра Макей on 17.11.2023.
//

import UIKit

class RoundedButton: UIButton {
    //MARK: - Life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    convenience init(title: String) {
          self.init(frame: .zero)
          setTitle(title, for: .normal)
      }
    
    //MARK: - Methods
    private func setupButton() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 8
        self.backgroundColor = UIColor.white
        self.setTitleColor(UIColor.black, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        
        self.titleEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
    }
}

