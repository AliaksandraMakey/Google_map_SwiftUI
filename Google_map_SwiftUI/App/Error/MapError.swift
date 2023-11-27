//
//  MapError.swift
//  Google_map_SwiftUI
//
//  Created by Александра Макей on 17.11.2023.
//

import Foundation

//MARK: - Map Error
enum MapError: Error {
    case invalidCoordinates
    case unableToRemoveMarker
    case unableToUpdatePath
}
