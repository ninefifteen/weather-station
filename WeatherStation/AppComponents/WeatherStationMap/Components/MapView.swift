//
//  MapView.swift
//  WeatherStation
//
//  Created by Shawn Seals on 1/14/23.
//

import MapKit
import SwiftUI

struct MapView: UIViewRepresentable {
    
    // MARK: - API
    
    init() {}
    
    // MARK: - Properties
    
    @EnvironmentObject var viewModel: WeatherStationMapViewModel
        
    // MARK: - UIViewRepresentable
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.setRegion(viewModel.initialRegion, animated: false)
        mapView.mapType = .standard
        mapView.isRotateEnabled = false
        mapView.delegate = context.coordinator
        viewModel.updateAnnotations(for: mapView)
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        viewModel.updateMapView(mapView)
    }
    
    // MARK: - Coordinator
    
    func makeCoordinator() -> MapCoordinator {
        .init(delegate: viewModel)
    }
    
    final class MapCoordinator: NSObject, MKMapViewDelegate {
        
        init(delegate: MKMapViewDelegate?) {
            self.delegate = delegate
        }
        
        private weak var delegate: MKMapViewDelegate?
                
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            delegate?.mapView?(mapView, viewFor: annotation)
        }
        
        func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
            delegate?.mapView?(mapView, didSelect: annotation)
        }
        
        func mapView(_ mapView: MKMapView, didDeselect annotation: MKAnnotation) {
            delegate?.mapView?(mapView, didDeselect: annotation)
        }
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            delegate?.mapViewDidChangeVisibleRegion?(mapView)
        }
    }
}
