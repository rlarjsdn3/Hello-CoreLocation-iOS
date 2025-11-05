//
//  LocationPushService.swift
//  PushServiceExtension
//
//  Created by 김건우 on 11/5/25.
//

import CoreLocation

class LocationPushService: NSObject, CLLocationPushServiceExtension, CLLocationManagerDelegate {

    var completion: (() -> Void)?
    var locationManager: CLLocationManager?

    func didReceiveLocationPushPayload(
        _ payload: [String : Any],
        completion: @escaping () -> Void
    ) {
        print("받은 페이로드: \(payload)")
        
        self.completion = completion
        self.locationManager = CLLocationManager()
        self.locationManager!.delegate = self
        self.locationManager!.requestLocation()
    }
    
    func serviceExtensionWillTerminate() {
        // Called just before the extension will be terminated by the system.
        self.completion?()
    }

    // MARK: - CLLocationManagerDelegate methods
    
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        print("받은 위치: \(locations)")
        guard let location = locations.last else { return }
        
        let timestamp = location.timestamp.description
        
        self.fetchCityAndCountry(location: location) { city, country, code, error in
            if let _ = error {
                print("리버스 지오코딩에 실패하였습니다.")
            } else {
                print("해당 위치의 국가와 지역은 \(city), \(country)(\(code))입니다. (시간: \(timestamp))")
            }
        }
        
        self.completion?()
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        self.completion?()
    }
    
    
    // MARK: - FetchCityAndCountry method
    
    func fetchCityAndCountry(
        location: CLLocation,
        completion: @escaping (_ city: String?, _ country: String?, _ code: String?, _ error: Error?) -> Void
    ) {
        CLGeocoder().reverseGeocodeLocation(location) { placemark, error in
            if let error = error {
                completion(nil, nil, nil, error)
            } else {
                let city = placemark?.first?.locality
                let country = placemark?.first?.country
                let code = placemark?.first?.isoCountryCode
                
                completion(city, country, code, nil)
            }
        }
    }

}

