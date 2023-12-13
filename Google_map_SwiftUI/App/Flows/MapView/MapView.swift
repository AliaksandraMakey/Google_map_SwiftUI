//
//  MapView.swift
//  Google_map_SwiftUI
//
//  Created by Александра Макей on 15.11.2023.
//

import SwiftUI
import GoogleMaps
import RxSwift

struct MapView: UIViewRepresentable {
    //MARK: - Properties
    @ObservedObject var mapViewModel = MapViewModel()
    var coordinator: Coordinator
    private let disposeBag = DisposeBag()
    
    init(mapViewModel: MapViewModel) {
        self.mapViewModel = mapViewModel
        self.coordinator = Coordinator(mapViewModel: mapViewModel)
    }
    /// coordinator
    func makeCoordinator() -> Coordinator {
        return coordinator
    }
    //MARK: - make UI components
    func makeUIView(context: Context) -> GMSMapView {
        let initialCamera = checkCameraPosition()
        let mapView = GMSMapView(frame: .zero, camera: initialCamera)
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true
        setupButtons(mapView, context: context)
        mapViewModel.mapStyleSettings.configureMapStyle(mapView)
        
        ///CLLocationManager
        configureLocationManager()
        mapView.delegate = context.coordinator
        context.coordinator.mapView = mapView
        
        return mapView
    }
    //MARK: - Update UI components
    func updateUIView(_ uiView: GMSMapView, context: Context) {}
    //MARK: - Metods
    func checkCameraPosition() -> GMSCameraPosition {
         let coordinates = mapViewModel.userCoordinates
            return GMSCameraPosition.camera(withTarget: coordinates, zoom: 12.0)
    }
    private func configureLocationManager() {
        var locationManager = mapViewModel.locationManager
        locationManager
            .authorithationStatus
            .bind { status in
                self.checkLocationStatus(status: status)
                }
            .disposed(by: disposeBag)

        locationManager
            .location
            .bind {  location in
                print("Location \(location)")
                coordinator.updateTrack(location: location)
                mapViewModel.currentLocation = location
            }
            .disposed(by: disposeBag)
    }
    private func checkLocationStatus(status: CLAuthorizationStatus) {
           print("Location status \(status)")
           switch status {
           case .notDetermined:
               mapViewModel.locationManager.requestAuthorithation()
           case .restricted, .denied:
               print("Location access denied")
           case .authorizedAlways, .authorizedWhenInUse:
               break
           @unknown default:
               break
           }

       }
}
//MARK: - Coordinator
extension MapView {
    class Coordinator: NSObject, GMSMapViewDelegate, CLLocationManagerDelegate {
        //MARK: - Properties
        var mapViewModel: MapViewModel
        var mapView: GMSMapView?
        lazy var dataBase: DataBaseLocationProtocol = RealmService()
        var trackLocation = false
        
        //MARK: - Life cicle
        init(mapViewModel: MapViewModel) {
            self.mapViewModel = mapViewModel
        }
        //MARK: - Action
        @objc func addMarkerTap(_ sender: UIButton) {
            if mapViewModel.marker == nil {
                guard let mapView = sender.superview as? GMSMapView else { return }
                mapViewModel.addMarker(mapView: mapView)
            } else {
                mapViewModel.removeMarker()
            }
        }
        @objc func trackUserLocationTap(_ sender: UIButton) {
            if trackLocation {
                finishTrack(model: mapViewModel)
                showCurrentPath(model: mapViewModel)
                stopLocation()
                sender.setTitle("Start", for: .normal)
            } else {
                startLocation()
                startNewTrack(model: mapViewModel)
                sender.setTitle("Stop", for: .normal)
            }
        }
        @objc func showCurrentLocationTap(_ sender: UIButton) {
             let coordinates = mapViewModel.userCoordinates
           
            let position = GMSCameraPosition(target: coordinates, zoom: 18)
            mapView?.animate(to: position)
        }
        func stopLocation(){
            mapViewModel.locationManager.stopUpdatingLocation()
            trackLocation = false
        }
        
        func startLocation(){
            mapViewModel.locationManager.startUpdatingLocation()
            trackLocation = true
        }
        private func clearRoute(model: MapViewModel) {
            model.route.map = nil
            model.route = GMSPolyline()
            model.routePath = GMSMutablePath()
            model.route.map = mapView
        }
        
        private func startNewTrack(model: MapViewModel) {
            if let mapView = self.mapView {
                mapView.clear()
            }
            clearRoute(model: model)
            if mapViewModel.mapStyleSettings.nowTime() {
                model.route.strokeColor = .white
                model.route.strokeWidth = 3
            } else {
                model.route.strokeColor = .green
                model.route.strokeWidth = 5
            }
 
            model.routePath = GMSMutablePath()
            model.route.map = mapView
        }
        private func finishTrack(model: MapViewModel) {
            do {
                try dataBase.deletePath(name: dataBase.defaultPathName)
                guard let routePath = model.route.path else { return }
                for i in 0..<routePath.count() {
                    let coordinate = routePath.coordinate(at: i)
                    try dataBase.addPoint(path: dataBase.defaultPathName, coordinate: coordinate)
                }
                print("Save path to DataBase completed")
            } catch {
                print("Error occurred: \(error)")
            }
        }
        private func showCurrentPath(model: MapViewModel) {
            do {
                let currentPath = try dataBase.loadPath(name: dataBase.defaultPathName)
                for coord in currentPath {
                    addPointToTrack(at: coord, model: model)
                }
                let bounds = GMSCoordinateBounds(path: model.routePath)
                mapView?.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 50.0))
            } catch {
                print("Error occurred in showPreviuosPath: \(error)")
            }
        }
        private func addPointToTrack(at coordinate: CLLocationCoordinate2D, model: MapViewModel) {
            model.routePath.add(coordinate)
            model.route.path = model.routePath
        }
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
         func updateTrack(location: CLLocationCoordinate2D) {
            if trackLocation {
                addPointToTrack(at: location, model: mapViewModel)
                let camera = GMSCameraPosition.camera(withTarget: location, zoom: 15)
                if let mapView = self.mapView {
                    mapView.animate(to: camera)
                    mapView.camera = camera
                } else {
                    print("Can't update track")
                }
            }
        }
        //MARK: - CLLocationManagerDelegate metods
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let location = locations.last else { return }
            if trackLocation {
                addPointToTrack(at: location.coordinate, model: mapViewModel)
                let position = GMSCameraPosition(target: location.coordinate, zoom: 15)
                mapView?.animate(to: position)
            }
            mapViewModel.userCoordinates = location.coordinate
        }
    }
}
extension MapView {
    //MARK: - Buttons
    func setupButtons(_ uiView: GMSMapView, context: Context) {
     
        // addMarkerButton
        let addMarkerButton = RoundedButton(title: "Add mark")
        addMarkerButton.addTarget(context.coordinator, action: #selector(Coordinator.addMarkerTap(_:)), for: .touchUpInside)
        uiView.addSubview(addMarkerButton)
        // updateLocationButton
        let trackUserLocationButton = RoundedButton(title: "Start")
        trackUserLocationButton.addTarget(context.coordinator, action: #selector(Coordinator.trackUserLocationTap(_:)), for: .touchUpInside)
        uiView.addSubview(trackUserLocationButton)
        // checkLocationButton
        let checkLocationButton = RoundedButton(title: "My location")
        checkLocationButton.addTarget(context.coordinator, action: #selector(Coordinator.showCurrentLocationTap(_:)), for: .touchUpInside)
        uiView.addSubview(checkLocationButton)
        
        let widthButton: CGFloat = 150
        let heightButton: CGFloat = 40
        NSLayoutConstraint.activate([
            /// addMarkerButton
            addMarkerButton.widthAnchor.constraint(equalToConstant: widthButton),
            addMarkerButton.heightAnchor.constraint(equalToConstant: heightButton),
            addMarkerButton.trailingAnchor.constraint(equalTo: uiView.trailingAnchor, constant: -10),
            addMarkerButton.topAnchor.constraint(equalTo: uiView.topAnchor, constant: 10),
            
            /// updateLocationButton
            trackUserLocationButton.widthAnchor.constraint(equalToConstant: widthButton),
            trackUserLocationButton.heightAnchor.constraint(equalToConstant: heightButton),
            trackUserLocationButton.trailingAnchor.constraint(equalTo: uiView.trailingAnchor, constant: -10),
            trackUserLocationButton.topAnchor.constraint(equalTo: addMarkerButton.bottomAnchor, constant: 5),
            
            /// checkLocationButton
            checkLocationButton.widthAnchor.constraint(equalToConstant: widthButton),
            checkLocationButton.heightAnchor.constraint(equalToConstant: heightButton),
            checkLocationButton.trailingAnchor.constraint(equalTo: uiView.trailingAnchor, constant: -10),
            checkLocationButton.topAnchor.constraint(equalTo: trackUserLocationButton.bottomAnchor, constant: 5),
        ])
    }
}
