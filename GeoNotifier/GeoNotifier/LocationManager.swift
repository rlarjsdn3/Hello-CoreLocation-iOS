//
//  LocationManager.swift
//  GeoNotifier
//
//  Created by 김건우 on 11/3/25.
//

import Combine
import CoreLocation
import Foundation

enum LocationError: Error {
    case authorizationDenied
    case unknown
}

final class LocationManager: NSObject {
    
    private var locationManager = CLLocationManager()
    
    @Published var monitor = PassthroughSubject<Bool, LocationError>()
    
    override init() {
        super.init()
        locationManager.delegate = self
        
        requestWhenInUseAuthorization()
    }
    
    func requestWhenInUseAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func requestAlwaysAuthorization() {
        locationManager.requestAlwaysAuthorization()
    }
    
    func setupGeofencing() throws(LocationError) {
        guard CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) else {
            throw .unknown
        }
        
        guard locationManager.authorizationStatus == .authorizedAlways else {
            throw .authorizationDenied
        }
        
        startMonitoring()
    }
    
    private func startMonitoring() {
        let regionCoordinate = CLLocationCoordinate2D(latitude: 37.3346438, longitude: -122.008972)
        let geofencingRegion = CLCircularRegion(
            center: regionCoordinate,
            radius: 100, // Radius in Meter
            identifier: "apple_park" // unique identifier
        )
        
        geofencingRegion.notifyOnEntry = true
        geofencingRegion.notifyOnExit = true
        
        // Start monitoring
        locationManager.startMonitoring(for: geofencingRegion)
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            print("When user did not yet determined")
        case .restricted:
            print("Restricted by parental control")
        case .denied:
            print("When user select option Don't Allow")
        case .authorizedAlways:
            print("Geofencing feature has user permission")
        case .authorizedWhenInUse:
            // Request Always Allow permission
            // after we obtain When In Use permission
            requestAlwaysAuthorization()
        default:
            print("default")
        }
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didEnterRegion region: CLRegion
    ) {
        guard let _ = region as? CLCircularRegion else { return }
        print("사용자가 조건 경계에 진입하였습니다. (식별자: \(region.identifier))")
        monitor.send(true)
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didExitRegion region: CLRegion
    ) {
        guard let _ = region as? CLCircularRegion else { return }
        print("사용자가 조건 경계로부터 벗어났습니다. (식별자: \(region.identifier))")
        monitor.send(false)
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        monitoringDidFailFor region: CLRegion?,
        withError error: any Error
    ) {
        guard let region = region else {
            print("The region could not be monitored, and the reason for the failure is not known.")
            return
        }
        
        print("There was a failure in monitoring the region with a identifier: \(region.identifier)")
    }
}
