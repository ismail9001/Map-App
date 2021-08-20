//
//  ViewController.swift
//  Map App
//
//  Created by macbook on 18.08.2021.
//

import UIKit
import GoogleMaps
import CoreLocation

class ViewController: UIViewController, GMSMapViewDelegate {
    
    @IBOutlet weak var mapView: GMSMapView!
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMap()
        configureLocationManager()
        checkLocationStatus()
    }
    
    private func configureMap() {
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
    }
    
    private func configureLocationManager() {
        locationManager.delegate = self
    }
    
    private func checkLocationStatus() {
        let locationStatus = locationManager.authorizationStatus
        switch locationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            print("Location access denied")
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        @unknown default:
            break
        }
    }
    
    private func addMarker(at coordinate: CLLocationCoordinate2D) {
        let marker = GMSMarker(position: coordinate)
        marker.map = mapView
    }
}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                                    longitude: location.coordinate.longitude)
            addMarker(at: coordinate)
            let camera = GMSCameraPosition(target: coordinate, zoom: 17)
            mapView.animate(to: camera)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
