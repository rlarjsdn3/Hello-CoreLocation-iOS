//
//  LocationHistoryView.swift
//  WalkRecorder
//
//  Created by 김건우 on 11/4/25.
//

import CoreLocation
import SwiftUI

struct LocationHistoryView: View {
    
    let locations: [CLLocation]
    
    var body: some View {
        List(locations, id: \.timestamp) { location in
            Text("\(location.coordinate)")
        }
    }
}


#Preview {
    let sampleLocations: [CLLocation] = [
        CLLocation(latitude: 37.5665, longitude: 126.9780), // 서울시청
        CLLocation(latitude: 37.5651, longitude: 126.9895), // 종로3가
        CLLocation(latitude: 37.5700, longitude: 126.9769), // 광화문
        CLLocation(latitude: 37.5714, longitude: 126.9910), // 종로5가
        CLLocation(latitude: 37.5760, longitude: 126.9850), // 안국역
        CLLocation(latitude: 37.5796, longitude: 126.9770), // 경복궁
        CLLocation(latitude: 37.5820, longitude: 126.9905), // 창덕궁
        CLLocation(latitude: 37.5790, longitude: 126.9960), // 혜화
        CLLocation(latitude: 37.5745, longitude: 127.0150), // 동대문
        CLLocation(latitude: 37.5653, longitude: 127.0090), // 을지로4가
        CLLocation(latitude: 37.5583, longitude: 126.9980), // 명동
        CLLocation(latitude: 37.5512, longitude: 126.9882), // 남산서울타워
        CLLocation(latitude: 37.5408, longitude: 127.0025), // 한남동
        CLLocation(latitude: 37.5302, longitude: 126.9970), // 용산
        CLLocation(latitude: 37.5208, longitude: 126.9826), // 이촌
        CLLocation(latitude: 37.5125, longitude: 127.1028), // 잠실
        CLLocation(latitude: 37.5006, longitude: 127.0364), // 강남역
        CLLocation(latitude: 37.4935, longitude: 127.0145), // 서초
        CLLocation(latitude: 37.4848, longitude: 126.9706), // 사당
        CLLocation(latitude: 37.4764, longitude: 126.9817)  // 서울대입구
    ]
    LocationHistoryView(locations: sampleLocations)
}
