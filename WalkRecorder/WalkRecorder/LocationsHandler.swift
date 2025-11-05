//
//  LocationsHandler.swift
//  WalkRecorder
//
//  Created by 김건우 on 11/4/25.
//

import CoreLocation
import Combine
import SwiftUI

@MainActor class LocationsHandler: ObservableObject {
    
    static let shared = LocationsHandler()
    private let manager: CLLocationManager
    private var background: CLBackgroundActivitySession?
    
    @Published var locations: [CLLocation] = []
    @Published var lastLocation = CLLocation()
    @Published var isStationary = false
    @Published var count = 0
    
    @Published
    var updatesStarted: Bool = UserDefaults.standard.bool(forKey: "liveUpdatesStarted") {
        didSet { UserDefaults.standard.set(updatesStarted, forKey: "liveUpdatesStarted") }
    }
    
    @Published
    var backgroundActivity: Bool = UserDefaults.standard.bool(forKey: "BGActivitySessionStarted") {
        didSet {
            backgroundActivity ? self.background = CLBackgroundActivitySession() : self.background?.invalidate()
            UserDefaults.standard.set(backgroundActivity, forKey: "BGActivitySessionStarted")
        }
    }
    
    private init() {
        self.manager = CLLocationManager()
    }
    
    func startLocationUpdates(runInBackgroundMode background: Bool = false) {
        print("Starting location updates (run in background: \(background))")
        if self.manager.authorizationStatus == .notDetermined {
            self.manager.requestWhenInUseAuthorization()
        }
        
        Task() {
            do {
                self.locations.removeAll()
                self.updatesStarted = true
                self.backgroundActivity = background
                let updates = CLLocationUpdate.liveUpdates()
                for try await update in updates {
                    if !self.updatesStarted { break }
                    if let loc = update.location {
                        self.locations.append(loc)
                        self.lastLocation = loc
                        self.isStationary = update.stationary
                        self.count += 1
                        print("Location \(self.count): \(self.lastLocation)")
                    }
                }
            } catch {
                print("Could not start location updates")
            }
            return
        }
    }
    
    func stopLocationUpdates() {
        print("Stopping location updates")
        self.updatesStarted = false
        self.backgroundActivity = false
    }
}


