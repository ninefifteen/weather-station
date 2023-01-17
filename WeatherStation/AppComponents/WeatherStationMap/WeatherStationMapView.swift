//
//  WeatherStationMapView.swift
//  WeatherStation
//
//  Created by Shawn Seals on 1/14/23.
//

import MapKit
import SwiftUI

struct WeatherStationMapView: View {
    
    // MARK: - API
    
    init() {
        _viewModel = StateObject(wrappedValue: WeatherStationMapViewModel())
    }
    
    // MARK: - Properties
    
    @StateObject private var viewModel: WeatherStationMapViewModel
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            MapView(initialRegion: viewModel.initialRegion, stations: viewModel.stations)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Picker("", selection: $viewModel.selectedDay) {
                    Text(viewModel.dayPickerTodayText).tag(Day.today)
                    Text(viewModel.dayPickerTomorrowText).tag(Day.tomorrow)
                }
                .pickerStyle(.segmented)
                .padding(.top, 12)
                .padding(.horizontal, 28)
                Spacer()
            }
            if viewModel.isLoading {
                LoadingOverlayView()
            }
        }
        .onAppear {
            Task {
                await viewModel.onAppear()
            }
        }
    }
}

struct WeatherStationMapView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherStationMapView()
    }
}
