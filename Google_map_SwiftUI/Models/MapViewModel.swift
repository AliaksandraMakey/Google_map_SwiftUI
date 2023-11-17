//
//  MapViewModel.swift
//  Google_map_SwiftUI
//
//  Created by Александра Макей on 15.11.2023.
//

import SwiftUI
import CoreLocation
import GoogleMaps


//MARK: - View Model
final class MapViewModel: ObservableObject {
    //MARK: - Properties
    //    @Published var coordinates = CLLocationCoordinate2D(latitude: 37.34033264974476, longitude: -122.06892632102273)
    @Published var coordinates: CLLocationCoordinate2D?
     var marker: GMSMarker?
    var geoCoder: CLGeocoder?
    var route: GMSPolyline?
    var routePath: GMSMutablePath?
    var locationManager: CLLocationManager?
        init() {
            routePath = GMSMutablePath()
        }
    //MARK: - Metods
    func updateCurrentLocation(_ location: CLLocation) {
        coordinates = location.coordinate
    }
    func addMarker(mapView: GMSMapView) -> Result<Void, MapError> {
        guard let coordinates = coordinates else {
            return .failure(.invalidCoordinates)
        }
        if marker == nil {
            mapView.animate(toLocation: coordinates)
            let newMarker = GMSMarker(position: coordinates)
            newMarker.title = "Marker"
            newMarker.snippet = "My new marker"
            newMarker.map = mapView
            marker = newMarker
        } else {
            removeMarker()
        }
        return .success(())
    }
    func updateLocation(mapView: GMSMapView, newLocation: CLLocation) {
           guard let currentCoordinates = coordinates else {
               updateCurrentLocation(newLocation)
               return
           }
           if currentCoordinates.latitude != newLocation.coordinate.latitude ||
               currentCoordinates.longitude != newLocation.coordinate.longitude {
               ///if the coordinates are different update the route
               if let route = route {
                   route.map = nil
               }
               routePath = GMSMutablePath()
               route = GMSPolyline()
               route?.map = mapView
           }
           ///Updating current coordinates
           updateCurrentLocation(newLocation)
           ///Continue with new location
           updatePath(with: newLocation, mapView: mapView)
       }
    func removeMarker() {
        marker?.map = nil
        marker = nil
    }
    func updatePath(with location: CLLocation, mapView: GMSMapView) {
        routePath?.add(location.coordinate)
        
        let locationsCount = routePath!.count()
        
        if locationsCount % 20 == 0 {
            ///Add a marker every n steps
            let blueMarker = GMSMarker(position: location.coordinate)
            blueMarker.icon = GMSMarker.markerImage(with: .blue)
            blueMarker.map = mapView
        }
        ///line setting
        route = GMSPolyline(path: routePath)
        route?.strokeColor = .green
        route?.strokeWidth = 3
        route?.map = mapView
    }
}
