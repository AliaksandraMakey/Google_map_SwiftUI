//
//  MapViewModel.swift
//  Google_map_SwiftUI
//
//  Created by Александра Макей on 15.11.2023.
//

import SwiftUI
import CoreLocation
import GoogleMaps

////MARK: - View Model
final class MapViewModel: ObservableObject {
    //MARK: - Properties
    var userCoordinates = CLLocationCoordinate2D(latitude: 37.34033264974476, longitude: -122.06892632102273)
    @Published var currentLocation: CLLocationCoordinate2D?
     var marker: GMSMarker?
    var geoCoder: CLGeocoder?
    lazy var route = GMSPolyline()
    lazy var routePath = GMSMutablePath()
    let locationManager = LocationManager.instance
    
    var mapStyleSettings = MapStyle()

    //MARK: - Metods
    func addMarker(mapView: GMSMapView, title: String = "", snippet: String = "") -> Result<Void, MapError> {
        if marker == nil {
            let marker = GMSMarker.init(position: userCoordinates)
            marker.icon = GMSMarker.markerImage(with: .red)
            marker.title = title
            marker.snippet = snippet
            marker.map = mapView
            mapView.animate(toLocation: userCoordinates)
        } else {
            removeMarker()
        }
        return .success(())
    }
    func removeMarker() {
        marker?.map = nil
        marker = nil
    }
}
