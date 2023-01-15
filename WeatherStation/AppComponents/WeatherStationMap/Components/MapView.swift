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
    
    let initialRegion: MKCoordinateRegion
    let stations: [Station]
    
    // MARK: - Properties
    
    private var stationAnnotations: [StationAnnotation] {
        stations.map { StationAnnotation(station: $0) }
    }
    
    // MARK: - UIViewRepresentable
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.setRegion(initialRegion, animated: false)
        mapView.mapType = .standard
        mapView.isRotateEnabled = false
        mapView.addAnnotations(stationAnnotations)
        mapView.delegate = context.coordinator
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        mapView.addAnnotations(stationAnnotations)
    }
    
    // MARK: - Coordinator
    
    func makeCoordinator() -> MapCoordinator {
        .init()
    }
    
    final class MapCoordinator: NSObject, MKMapViewDelegate {
        
        private let clusterAnnotationIdentifier = "cluster"
        private let stationAnnotationIdentifier = "station"
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            switch annotation {
            case let cluster as MKClusterAnnotation:
                return annotationView(for: cluster, in: mapView)
            case let stationAnnotation as StationAnnotation:
                return annotationView(for: stationAnnotation, in: mapView)
            default:
                return nil
            }
        }
        
        private func annotationView(
            for cluster: MKClusterAnnotation,
            in mapView: MKMapView
        ) -> MKAnnotationView {
            
            let annotationView: MKMarkerAnnotationView
            
            if let view = mapView.dequeueReusableAnnotationView(
                withIdentifier: clusterAnnotationIdentifier
            ) as? MKMarkerAnnotationView {
                annotationView = view
            } else {
                annotationView = MKMarkerAnnotationView(annotation: cluster, reuseIdentifier: clusterAnnotationIdentifier)
            }
            
            let stations = cluster.memberAnnotations.compactMap({ $0 as? StationAnnotation }).map { $0.station }
            
            if let averageTemperature = stations.averageTemperature() {
                annotationView.glyphText = String(format: "%.0f°", averageTemperature)
            } else {
                annotationView.glyphText = ""
            }
            annotationView.titleVisibility = .hidden
            return annotationView
        }
        
        private func annotationView(
            for stationAnnotation: StationAnnotation,
            in mapView: MKMapView
        ) -> MKAnnotationView {
            
            let annotationView: MKMarkerAnnotationView
            
            if let view = mapView.dequeueReusableAnnotationView(
                withIdentifier: stationAnnotationIdentifier
            ) as? MKMarkerAnnotationView {
                annotationView = view
            } else {
                annotationView = MKMarkerAnnotationView(
                    annotation: stationAnnotation,
                    reuseIdentifier: stationAnnotationIdentifier
                )
            }
            
            annotationView.canShowCallout = true
            
            if let temperature = stationAnnotation.station.temperature {
                annotationView.glyphText = String(format: "%.0f°", temperature)
            } else {
                annotationView.glyphText = ""
            }
            
            annotationView.clusteringIdentifier = "cluster"
            annotationView.titleVisibility = .hidden
            
            let calloutView = StationCalloutView(station: stationAnnotation.station)
            annotationView.detailCalloutAccessoryView = calloutView
            
            return annotationView
        }
        
        func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
//            print("regionWillChange region: \(mapView.region)")
        }
        
        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
//            print("regionDidChange region: \(mapView.region)")
        }
        
        // Updates as you drag.
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
//            print("mapViewDidChangeVisibleRegion: \(mapView.region)")
        }
    }
}
