//
//  ContentView.swift
//  GeofenceHopper
//
//  Created by Takano Masanori on 2023/09/29.
//

import SwiftUI
import CoreLocation
import MapKit
import SwiftData

struct ContentView: View {
    
    @Environment(\.modelContext) var context
    @Query private var locationHistories: [LocationHistory]
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 35.6895, 
                                       longitude: 139.6917),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    @State private var polyline: MKPolyline? = nil

    @State private var viewModel: ViewModel
    @State private var showAlert = false

    var body: some View {
        ZStack {
            Color.red
                .ignoresSafeArea()
            
            Map {
                MapPolyline(coordinates: locationHistories.map({
                    CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)
                }))
                .stroke(.blue, lineWidth: 5)
                UserAnnotation()
            }
            VStack {
                Spacer()
                Button(action: {
                    showAlert = true
                }, label: {
                    Text("Delete All logs")
                        .foregroundColor(.black)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                })
                .padding(.bottom, 20)
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Warning"),
                          message: Text("すべてのログを削除しますか？"),
                          primaryButton: .destructive(Text("Delete")) {
                        viewModel.deleteAllData()
                    },
                          secondaryButton: .cancel())
                }
            }
        }.ignoresSafeArea()
    }
    
    init(modelContext: ModelContext) {
        let viewModel = ViewModel(modelContext: modelContext)
        _viewModel = State(initialValue: viewModel)
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            // Handle the result
        }
    }
}

#Preview {
    ContentView(modelContext: try! ModelContainer(for: LocationHistory.self).mainContext)
}