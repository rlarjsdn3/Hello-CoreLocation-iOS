//
//  HeadingMarkerView.swift
//  CompassApp
//
//  Created by 김건우 on 11/3/25.
//

import CoreLocation
import SwiftUI

struct HeadingMarkerView: View {
    
    @Binding var degrees: CLLocationDirection
    
    init(degrees: Binding<Double>) {
        self._degrees = degrees
    }
    
    var body: some View {
        ZStack {
            ForEach(0..<90) { index in
                Rectangle()
                    .offset(y: 150)
                    .frame(width: 1, height: 10)
                    .rotationEffect(Angle(degrees: Double(index * 4)))
            }
            
            headingTexts("북", "남")
            headingTexts("서", "동")
                .rotationEffect(Angle(degrees: -90))
            
            Image(systemName: "arrowshape.up.fill")
                .font(.largeTitle)
                .fontWeight(.black)
                .foregroundStyle(.red)
                .rotationEffect(Angle(degrees: degrees))
        }
    }
    
    func headingTexts(_ left: String, _ right: String) -> some View {
        VStack {
            Text(left)
            Spacer()
            Text(right)
        }
        .font(.title)
        .frame(height: 400)
    }
}

fileprivate extension View {
    
    @ViewBuilder
    func `if`<Content: View>(
        _ conditional: () -> Bool,
        transform: (Self) -> Content
    ) -> some View {
        if conditional() { transform(self) }
        else { self }
    }
}

#Preview {
    @Previewable @State var degrees: Double = 0.0
    HeadingMarkerView(degrees: $degrees)
}
