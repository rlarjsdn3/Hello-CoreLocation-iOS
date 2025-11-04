//
//  ContentView.swift
//  CompassApp
//
//  Created by 김건우 on 11/3/25.
//

import SwiftUI

struct ContentView: View {
    
    @Bindable var locationManager = LocationManager()
    
    var body: some View {
        HeadingMarkerView(degrees: $locationManager.degrees)
            .onAppear {
                locationManager.startUpdatingHeading()
            }
    }
}

#Preview {
    ContentView()
}
