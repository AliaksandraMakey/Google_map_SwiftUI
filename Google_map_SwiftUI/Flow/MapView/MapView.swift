//
//  MapView.swift
//  Google_map_SwiftUI
//
//  Created by Александра Макей on 15.11.2023.
//

import SwiftUI
import GoogleMaps

struct MapView: UIViewRepresentable {
    //MARK: - Properties
    @ObservedObject var mapViewModel = MapViewModel()
    var mapStyleSettings = MapStyle()
    /// coordinator
    func makeCoordinator() -> Coordinator {
        return Coordinator( mapViewModel: mapViewModel)
    }
    
    //MARK: - make UI components
    func makeUIView(context: Context) -> GMSMapView {
        let initialCamera = checkCameraPosition()
        let mapView = GMSMapView(frame: .zero, camera: initialCamera)
        setupButtons(mapView, context: context)
        mapStyleSettings.configureMapStyle(mapView)
        
        ///CLLocationManager configuration and permission request
        let locationManager = CLLocationManager()
        locationManager.delegate = context.coordinator
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        mapViewModel.locationManager = locationManager
        
        mapView.delegate = context.coordinator
        context.coordinator.mapView = mapView
        
        return mapView
    }
    //MARK: - Buttons
    func setupButtons(_ uiView: GMSMapView, context: Context) {
        // addMarkerButton
        let addMarkerButton = RoundedButton(type: .system)
        addMarkerButton.setTitle("Add marker", for: .normal)
        addMarkerButton.addTarget(context.coordinator, action: #selector(Coordinator.addMarker(_:)), for: .touchUpInside)
        uiView.addSubview(addMarkerButton)
        
        /// constraints
        NSLayoutConstraint.activate([
            addMarkerButton.trailingAnchor.constraint(equalTo: uiView.trailingAnchor, constant: -10),
            addMarkerButton.bottomAnchor.constraint(equalTo: uiView.bottomAnchor, constant: -10),
            addMarkerButton.widthAnchor.constraint(equalToConstant: 120),
            addMarkerButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // updateLocationButton
        let updateLocationButton = RoundedButton(type: .system)
        updateLocationButton.setTitle("Update Location", for: .normal)
        //        updateLocationButton.addTarget(context.coordinator, action: #selector(Coordinator.updateLocation(_:)), for: .touchUpInside)
        uiView.addSubview(updateLocationButton)
        
        ///constraints
        NSLayoutConstraint.activate([
            updateLocationButton.trailingAnchor.constraint(equalTo: uiView.trailingAnchor, constant: -10),
            updateLocationButton.bottomAnchor.constraint(equalTo: addMarkerButton.topAnchor, constant: -10),
            updateLocationButton.widthAnchor.constraint(equalToConstant: 160),
            updateLocationButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    //MARK: - Update UI components
    func updateUIView(_ uiView: GMSMapView, context: Context) {}
    //MARK: - Metods
     func checkCameraPosition() -> GMSCameraPosition {
        if let coordinates = mapViewModel.coordinates {
            return GMSCameraPosition.camera(withTarget: coordinates, zoom: 12.0)
        } else {
            return GMSCameraPosition.camera(withLatitude: 37.34033264974476, longitude: -122.06892632102273, zoom: 12.0)
        }
    }
}
//MARK: - Coordinator
extension MapView {
    class Coordinator: NSObject, GMSMapViewDelegate, CLLocationManagerDelegate {
        //MARK: - Properties
        var mapViewModel: MapViewModel
        var mapView: GMSMapView?
        
        //MARK: - Life cicle
        init(mapViewModel: MapViewModel) {
            self.mapViewModel = mapViewModel
        }
        
        //MARK: - Action
        @objc func addMarker(_ sender: UIButton) {
            guard let mapView = sender.superview as? GMSMapView else { return }
            mapViewModel.addMarker(mapView: mapView)
        }
        //        @objc func updateLocation(_ sender: UIButton) {
        //            guard let mapView = sender.superview as? GMSMapView else { return }
        //            guard let lastLocation = mapViewModel.locationManager?.location else { return }
        //            mapViewModel.updateLocation(mapView: mapView, newLocation: lastLocation)
        //        }
        //MARK: - GMSMapViewDelegate methods
        func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
            let manualMarker = GMSMarker(position: coordinate)
            manualMarker.map = self.mapView
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            
            let geoCoder = CLGeocoder()
            geoCoder.reverseGeocodeLocation(location) { places, error in
                print(places?.last)
            }
        }
        //MARK: - CLLocationManagerDelegate metods
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let location = locations.last else { return }
            guard let mapView = mapView else { return }
            mapViewModel.updatePath(with: location, mapView: mapView)
            mapViewModel.coordinates = location.coordinate
            
            let position = GMSCameraPosition(target: location.coordinate, zoom: 15)
            mapView.animate(to: position)
        }
    }
}
