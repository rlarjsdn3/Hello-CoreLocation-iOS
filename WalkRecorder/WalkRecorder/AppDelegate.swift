//
//  AppDelegate.swift
//  WalkRecorder
//
//  Created by 김건우 on 11/4/25.
//

import SwiftUI

@Observable
class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        let locationsHandler = LocationsHandler.shared
        
        // 앱이 종료(terminate)되고 다시 실행되더라도,
        // UserDefaults에 저장된 값을 보고 위치 추적을 재개할지 말지 결정합니다.
        if locationsHandler.updatesStarted {
            locationsHandler.startLocationUpdates()
        }
        // 앱이 종료(terminate)되고 다시 실행되더라도,
        // UserDefaults에 저장된 값을 보고 백그라운드에서도 위치 추적을 재개할지 말지 결정합니다.
        if locationsHandler.backgroundActivity {
            locationsHandler.backgroundActivity = true
        }
        return true
    }
}
