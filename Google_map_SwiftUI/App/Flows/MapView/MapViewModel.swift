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
    @Published var userCoordinates: CLLocationCoordinate2D?
     var marker: GMSMarker?
    var geoCoder: CLGeocoder?
    lazy var route = GMSPolyline()
    lazy var routePath = GMSMutablePath()
    lazy var locationManager = CLLocationManager()
    var mapStyleSettings = MapStyle()

    //MARK: - Metods
    func addMarker(mapView: GMSMapView, title: String = "", snippet: String = "") -> Result<Void, MapError> {
        guard let coordinates = userCoordinates else {
            return .failure(.invalidCoordinates)
        }
        if marker == nil {
            let marker = GMSMarker.init(position: coordinates)
            marker.icon = GMSMarker.markerImage(with: .red)
            marker.title = title
            marker.snippet = snippet
            marker.map = mapView
            mapView.animate(toLocation: coordinates)
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
