//
//  DriverDetailView.swift
//  F1Stats
//
//  Created by Pál Gábor on 26/08/2024.
//

import SwiftUI

struct DriverDetailView: View {
    @StateObject private var viewModel: DriverDetailViewModel
    
    init(driverId: String) {
        _viewModel = StateObject(wrappedValue: DriverDetailViewModel(driverId: driverId))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if let driver = viewModel.driver {
                    DriverHeaderView(driver: driver, image: viewModel.driverImage)
                    DriverInfoView(driver: driver)
                    WikipediaLinkView(driverName: driver.familyName)
                } else {
                    ProgressView("Loading...")
                }
            }
            .padding()
        }
        .navigationTitle("Driver Details")
        .onAppear { viewModel.fetchDriverDetails() }
    }
}
