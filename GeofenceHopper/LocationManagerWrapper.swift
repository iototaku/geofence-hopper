//
//  LocationManagerWrapper.swift
//  GeofenceHopper
//
//  Created by Takano Masanori on 2023/09/29.
//


import Foundation
import CoreLocation
import MapKit
import SwiftData
import SwiftUI
import Combine

final class LocationManagerWrapper: NSObject, CLLocationManagerDelegate {

    private let locationManager = CLLocationManager()
    
    let locaitonPublisher: AnyPublisher<CLLocation?, Never>
    private let locaitonSubject = CurrentValueSubject<CLLocation?, Never>(nil)
    
    override init(){
        locaitonPublisher = locaitonSubject.eraseToAnyPublisher()

        super.init()
        locationManager.delegate = self
        locationManager.distanceFilter = 0.0
        locationManager.activityType = CLActivityType.other
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.requestAlwaysAuthorization()
        stopMonitoringAllRegions()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            locaitonSubject.send(location)
            stopMonitoringAllRegions()
            startMonitoringGeofence(coordinate: location.coordinate)
        }
    }
    
    func stopMonitoringAllRegions() {
        for region in locationManager.monitoredRegions {
            locationManager.stopMonitoring(for: region)
        }
    }
        
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways:
            locationManager.requestLocation()
        default:
            locationManager.requestAlwaysAuthorization()
        }
    }

    func startMonitoringGeofence(coordinate: CLLocationCoordinate2D) {
        let newGeofence = CLCircularRegion(center: coordinate,
                                           radius: 200,
                                           identifier: "NewGeofence")
        self.locationManager.startMonitoring(for: newGeofence)
        Notification.doNotification(message: "didSetGeofence!")
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        locationManager.requestState(for: region)
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        if state == .outside {
            locationManager.requestLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error.localizedDescription)")
    }
}
