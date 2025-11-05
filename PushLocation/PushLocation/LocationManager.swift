//
//  LocationManager.swift
//  PushLocation
//
//  Created by 김건우 on 11/5/25.
//

import CoreLocation
import Foundation

@MainActor final class LocationManager: NSObject {
    
    private let locationManager = CLLocationManager()
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.requestWhenInUseAuthorization()
        
        startMonitoringPush()
    }
    
    func startMonitoringPush() {
        locationManager.startMonitoringLocationPushes { token, error in
            if let error = error {
                print("위치 푸시 모니터링을 시작할 수 없습니다: \(error.localizedDescription)")
                return
            }
            
            guard let token = token else {
                print("APNs 토큰을 발급받지 못했습니다.")
                return
            }
            
            let retrived = token.map { String(format: "%02.2hhx", $0) }.joined()
            print("발급 받은 위치 푸시 APNs 토큰: \(retrived)")
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse {
            locationManager.requestAlwaysAuthorization()
        }
    }
}
