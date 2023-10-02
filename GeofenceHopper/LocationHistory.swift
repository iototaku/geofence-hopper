//
//  LocationHistory.swift
//  GeofenceHopper
//
//  Created by Takano Masanori on 2023/10/02.
//

import Foundation
import CoreLocation
import SwiftData

@Model
final class LocationHistory {
    let latitude: Double
    let longitude: Double
    let timestamp: Date

    init(location: CLLocation) {
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
        self.timestamp = location.timestamp
    }
}
