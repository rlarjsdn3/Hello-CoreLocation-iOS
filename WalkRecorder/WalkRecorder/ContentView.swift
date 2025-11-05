//
//  ContentView.swift
//  WalkRecorder
//
//  Created by 김건우 on 11/4/25.
//

import SwiftUI
import MapKit

struct ContentView: View {
    
    @StateObject var locationsHandler = LocationsHandler.shared
    
    @State private var showPolyline: Bool = false
    @State private var showLocationHistorySheet: Bool = false
    
    var points: [MKMapPoint] {
        locationsHandler.locations.map { location in
            MKMapPoint(location.coordinate)
        }
    }
    
    var body: some View {
        NavigationStack {
            Map {
                Annotation(
                    "현재 위치",
                    coordinate: locationsHandler.lastLocation.coordinate
                ) {
                    Circle()
                        .foregroundStyle(.blue)
                }
                
                if showPolyline {
                    MapPolyline(
                        points: points,
                        contourStyle: .straight
                    )
                    .stroke(.blue, lineWidth: 3)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showPolyline.toggle()
                    } label: {
                        Image(systemName: showPolyline ? "eraser.fill" : "pencil.line")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showLocationHistorySheet = true
                    } label: {
                        Image(systemName: "figure.walk")
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Menu {
                        Button {
                            locationsHandler.stopLocationUpdates()
                        } label: {
                            Label("위치 추적 중지하기", systemImage: "pause.fill")
                        }
                        
                        Divider()
                        
                        Button {
                            locationsHandler.startLocationUpdates(runInBackgroundMode: false)
                        } label: {
                            Label(
                                "Foreground에서 위치 추적하기",
                                systemImage: "iphone.gen3.badge.location"
                            )
                        }
                        Button {
                            locationsHandler.startLocationUpdates(runInBackgroundMode: true)
                        } label: {
                            Label(
                                "Background에서 위치 추적하기",
                                systemImage: "iphone.gen3.badge.location"
                            )
                        }
                    } label: {
                        Image(systemName: locationsHandler.updatesStarted ? "pause.fill" : "play.fill")
                    }
                }
            }
            .sheet(isPresented: $showLocationHistorySheet) {
                NavigationStack {
                    LocationHistoryView(locations: locationsHandler.locations)
                        .navigationTitle("Location History")
                        .navigationBarTitleDisplayMode(.inline)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
