//
//  AsyncLocationManager.swift
//  CompassApp
//
//  Created by 김건우 on 11/3/25.
//

import CoreLocation
import Foundation
import SwiftUI

@Observable
final class LocationManager: NSObject {
    
    private let locationManager = CLLocationManager()
    
    var degrees: CLLocationDirection = 0.0
    
    override init() {
        super.init()
        
        requestWhenInUseAuthorization()
        locationManager.delegate = self
    }
    
    func requestWhenInUseAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startUpdatingHeading() {
        locationManager.startUpdatingHeading()
    }
    
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            print("위치 서비스 접근 권한이 아직 결정되지 않았습니다.")
        case .denied, .restricted:
            print("위치 서비스 접근 권한이 거부되거나 제한되어 있습니다.")
        case .authorizedAlways, .authorizedWhenInUse:
            print("위치 서비스 접근 권한이 허용되어 있습니다.")
        default:
            print("위치 서비스 접근 권한이 알 수 없는 상태입니다.")
        }
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateHeading newHeading: CLHeading
    ) {
        degrees = newHeading.magneticHeading
    }
}
