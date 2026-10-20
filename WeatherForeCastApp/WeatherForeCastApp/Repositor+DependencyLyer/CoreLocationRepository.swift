//
//  CoreLocationRepository.swift
//  WeatherForeCastApp
//
//  Created by Anusha on 10/19/26.
//

import Foundation
import CoreLocation

@MainActor
protocol LocationService: AnyObject {
    var authorizationStatus: CLAuthorizationStatus { get }

    func requestWhenInUseAuthorization()
    func requestCurrentLocation()

    var onLocationUpdate: ((CLLocationCoordinate2D) -> Void)? { get set }
    var onAuthorizationChange: ((CLAuthorizationStatus) -> Void)? { get set }
}
final class DefaultLocationService: NSObject {

    private let manager = CLLocationManager()
    override init() {
           super.init()
           manager.delegate = self
           manager.desiredAccuracy = kCLLocationAccuracyBest
       }
    var onLocationUpdate: ((CLLocationCoordinate2D) -> Void)?
    var onAuthorizationChange: ((CLAuthorizationStatus) -> Void)?
}
extension DefaultLocationService: LocationService {

    var authorizationStatus: CLAuthorizationStatus {
        manager.authorizationStatus
    }

    func requestWhenInUseAuthorization(){
        manager.requestWhenInUseAuthorization()
    }

    func requestCurrentLocation() {
        manager.requestLocation()
    }
}
extension DefaultLocationService: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {

        let status = manager.authorizationStatus
        onAuthorizationChange?(status)

        switch status {

        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()   // 🔥 IMPORTANT FIX

        case .notDetermined, .denied, .restricted:
            break

        @unknown default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {

        guard let location = locations.first else { return }

        onLocationUpdate?(location.coordinate)
    }

    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
        print("Location error:", error)
    }
}
