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
    
    let stations: [Station]
    
    init(displayRegion: Binding<MKCoordinateRegion>, stations: [Station]) {
        _displayRegion = displayRegion
        self.stations = stations
    }
    
    // MARK: - Properties
    
    @Binding private var displayRegion: MKCoordinateRegion
    
    private var stationAnnotations: [StationAnnotation] {
        stations.map { StationAnnotation(station: $0) }
    }
    
    // MARK: - UIViewRepresentable
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.setRegion(displayRegion, animated: false)
        mapView.mapType = .standard
        mapView.isRotateEnabled = false
        mapView.addAnnotations(stationAnnotations)
        mapView.delegate = context.coordinator
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        context.coordinator.isSwitching = true
        let oldAnnotations = mapView.annotations
        mapView.addAnnotations(stationAnnotations)
        mapView.removeAnnotations(oldAnnotations)
        reselectSelectedAnnotationId(mapView, context: context)
        context.coordinator.isSwitching = false
    }
    
    // MARK: = Functions
    
    func reselectSelectedAnnotationId(_ mapView: MKMapView, context: Context) {
        guard let selectedStationId = context.coordinator.selectedStationId,
              let selectedAnnotation = mapView.annotations.first(where: { annotation in
                  if let stationAnnotation = annotation as? StationAnnotation {
                      return stationAnnotation.station.id == selectedStationId
                  }
                  return false
              }) else { return }
        mapView.selectAnnotation(selectedAnnotation, animated: false)
    }
    
    // MARK: - Coordinator
    
    func makeCoordinator() -> MapCoordinator {
        .init(displayRegion: $displayRegion)
    }
    
    final class MapCoordinator: NSObject, MKMapViewDelegate {
        
        init(displayRegion: Binding<MKCoordinateRegion>) {
            _displayRegion = displayRegion
        }
        
        private let stationAnnotationIdentifier = "station"
        
        @Binding private var displayRegion: MKCoordinateRegion
        
        var selectedStationId: String?
        var isSwitching = false
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard let stationAnnotation = annotation as? StationAnnotation else { return nil }
            return annotationView(for: stationAnnotation, in: mapView)
        }
        
        private func annotationView(
            for stationAnnotation: StationAnnotation,
            in mapView: MKMapView
        ) -> MKAnnotationView {
            let annotationView: StationAnnotationView

            if let view = mapView.dequeueReusableAnnotationView(
                withIdentifier: stationAnnotationIdentifier
            ) as? StationAnnotationView {
                annotationView = view
            } else {
                annotationView = StationAnnotationView(
                    annotation: stationAnnotation,
                    reuseIdentifier: stationAnnotationIdentifier
                )
            }
            
            annotationView.displayPriority = .defaultHigh
            annotationView.canShowCallout = true

            if let temperature = stationAnnotation.station.temperature {
                annotationView.label.text = String(format: "%.0f°", temperature)
            } else {
                annotationView.label.text = ""
            }
            
            let calloutView = StationCalloutView(station: stationAnnotation.station)
            annotationView.detailCalloutAccessoryView = calloutView

            return annotationView
        }
        
        func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
            if let stationAnnotation = annotation as? StationAnnotation {
                selectedStationId = stationAnnotation.station.id
            }
        }
        
        func mapView(_ mapView: MKMapView, didDeselect annotation: MKAnnotation) {
            if let _ = annotation as? StationAnnotation, !isSwitching {
                selectedStationId = nil
            }
        }
        
        func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
//            print("regionWillChange region: \(mapView.region)")
        }
        
        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
//            print("regionDidChange region: \(mapView.region)")
        }
        
        // Updates as you drag.
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            displayRegion = mapView.region
        }
    }
}
