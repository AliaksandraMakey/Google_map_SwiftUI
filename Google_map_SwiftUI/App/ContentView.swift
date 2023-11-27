//
//  ContentView.swift
//  Google_map_SwiftUI
//
//  Created by Александра Макей on 15.11.2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Spacer(minLength: 20)
            
            MapView(mapViewModel: MapViewModel())
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 40)
                .padding(.vertical, 20)
            
            Spacer(minLength: 30)
        }
    }
}

#Preview {
    ContentView()
}
