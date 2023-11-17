//
//  LocationManager.swift
//  Google_map_SwiftUI
//
//  Created by Александра Макей on 17.11.2023.
//


import Foundation
import CoreLocation

final class LocationManager: NSObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        // Передача информации о локации в MapViewModel
//         mapViewModel?.updateLocation(newLocation: location)
    }
}
