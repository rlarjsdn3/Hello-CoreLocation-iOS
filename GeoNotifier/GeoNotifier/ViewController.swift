//
//  ViewController.swift
//  GeoNotifier
//
//  Created by 김건우 on 9/25/25.
//

import Combine
import UIKit

final class ViewController: UIViewController {

    private var cancellables = Set<AnyCancellable>()
    
    private let locationManager = LocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    private func bind() {
        locationManager.monitor
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] error in
                self?.showAlert(message: "조건 경계 모니터링에 실패하였습니다: \(error)")
            }, receiveValue: { _ in })
            .store(in: &cancellables)
    }
    
    @IBAction func startMonitoringRegion(_ sender: Any) {
        setupGeofencing()
    }
    
    private func setupGeofencing() {
        do {
            try locationManager.setupGeofencing()
        } catch {
            switch error {
            case .authorizationDenied:
                showAlert(message: "App does not have correct location authorization")
            case .unknown:
                showAlert(message: "Geofencing is not supported on this device")
            }
        }
    }

}

extension ViewController {
    
    private func showAlert(message: String) {
        let alertController = UIAlertController(
            title: "Information",
            message: message,
            preferredStyle: .alert
        )
        alertController.addAction(
            UIAlertAction(title: "OK", style: .default)
        )
        self.present(alertController, animated: true)
    }
}

