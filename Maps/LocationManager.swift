//
//  LocationManager.swift
//  Maps
//
//  Created by Коломенский Александр on 22.10.2021.
//

import Foundation
import CoreLocation
import RxSwift
import RxCocoa

final class LocationManager: NSObject {

    private let locationManager = CLLocationManager()

    static let instance = LocationManager()

    let authorithationStatus = BehaviorRelay<CLAuthorizationStatus>(value: .notDetermined)
    let location = PublishRelay<CLLocationCoordinate2D>()

    private override init() {
        super.init()
        configureLocationManager()
    }

    private func configureLocationManager() {
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.showsBackgroundLocationIndicator = true

        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.requestAlwaysAuthorization()
    }

    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }

    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }

    func requestAuthorithation() {
        locationManager.requestAlwaysAuthorization()
    }


}

extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorithationStatus.accept(manager.authorizationStatus)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        locations.forEach{
            location.accept($0.coordinate)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
