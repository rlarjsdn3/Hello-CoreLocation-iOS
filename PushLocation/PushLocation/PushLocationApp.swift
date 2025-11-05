//
//  PushLocationApp.swift
//  PushLocation
//
//  Created by 김건우 on 11/5/25.
//

import SwiftUI

@main
struct PushLocationApp: App {
    private let locationManager = LocationManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    locationManager.setupLocationManager()
                }
        }
    }
}
