//
//  ViewModel.swift
//  GeofenceHopper
//
//  Created by Takano Masanori on 2023/10/02.
//

import Foundation
import CoreLocation
import MapKit
import SwiftData
import SwiftUI
import Combine

@Observable
class ViewModel {
    
    private let locationManager = LocationManagerWrapper()
    private let historyLimit = 50
    private var modelContext: ModelContext
    private var cancellables = Set<AnyCancellable>()

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        locationManager.locaitonPublisher.compactMap{ $0 }.sink { [weak self] location in
            guard let self = self else { return }
            self.addData(location: location)
        }.store(in: &cancellables)
    }

    func addData(location: CLLocation) {
        if let locationHistories = fetchData(), locationHistories.count >= historyLimit, let oldLocation = locationHistories.first {
            modelContext.delete(oldLocation)
        }
        modelContext.insert(LocationHistory(location: location))
    }
    
    func deleteAllData() {
        if let locationHistories = fetchData() {
            for history in locationHistories {
                modelContext.delete(history)
            }
        }
    }
    
    func fetchData() -> [LocationHistory]? {
        do {
            let descriptor = FetchDescriptor<LocationHistory>(sortBy: [SortDescriptor(\.timestamp)])
            let histories = try modelContext.fetch(descriptor)
            return histories
        } catch {
            print("Fetch failed")
        }
        return nil
    }
}
