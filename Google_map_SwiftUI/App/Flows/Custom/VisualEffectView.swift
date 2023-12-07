//
//  VisualEffectView.swift
//  Google_map_SwiftUI
//
//  Created by Александра Макей on 06.12.2023.
//

import UIKit
import SwiftUI

struct VisualEffectView: UIViewRepresentable {
    let style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: blurEffect)
        return blurView
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}
