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
            MapView()
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
                Picker("", selection: $viewModel.selectedStationField) {
                    Text(viewModel.fieldPickerTemperatureText).tag(StationField.temperature)
                    Text(viewModel.fieldPickerWindText).tag(StationField.wind)
                    Text(viewModel.fieldPickerPrecipitationText).tag(StationField.precipitation)
                }
                .pickerStyle(.segmented)
                .padding(.bottom, 32)
                .padding(.horizontal, 28)
            }
            if viewModel.isLoading {
                LoadingOverlayView()
            }
        }
        .alert(viewModel.alertTitle, isPresented: $viewModel.isAlertShown, actions: {
            Button("OK", role: .cancel) {}
        }, message: {
            Text(viewModel.alertMessage)
        })
        .onAppear {
            Task {
                await viewModel.onAppear()
            }
        }
        .environmentObject(viewModel)
    }
}

struct WeatherStationMapView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherStationMapView()
    }
}
