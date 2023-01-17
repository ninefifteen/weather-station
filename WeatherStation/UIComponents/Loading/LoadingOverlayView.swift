//
//  LoadingOverlayView.swift
//  WeatherStation
//
//  Created by Shawn Seals on 1/16/23.
//

import SwiftUI

struct LoadingOverlayView: View {
    var body: some View {
        ZStack {
            Color(uiColor: UIColor.systemBackground)
                .opacity(0.8)
                .transition(.opacity.animation(.easeInOut(duration: 0.25)))
            ProgressView()
                .scaleEffect(3)
        }
        .ignoresSafeArea(.all)
    }
}

struct LoadingOverlayView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingOverlayView()
    }
}
