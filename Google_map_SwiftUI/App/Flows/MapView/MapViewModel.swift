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
    let userMarkerDefaultImage = FilesManager.defaultUserMarkerImage
    var userMarkerImage: UIImage? = {
        return FilesManager.loadImageFromDiskWith(fileName: FilesManager.userImageName)
    }()

    var userMarker: GMSMarker?
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
     func setUserMarker(mapView: GMSMapView, at coordinate: CLLocationCoordinate2D) {
        let imageView: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        
        let marker = userMarker ?? GMSMarker(position: coordinate)
        let imageToUse = userMarkerImage ?? userMarkerDefaultImage
        
        imageView.image = imageToUse
        imageView.rounded()
        marker.position = coordinate
        marker.iconView = imageView
        marker.map = mapView
        self.userMarker = marker
    }
}
