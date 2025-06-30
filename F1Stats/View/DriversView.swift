//
//  DriversView.swift
//  F1Stats
//
//  Created by Pál Gábor on 26/08/2024.
//

import SwiftUI

struct DriversView: View {
    @StateObject private var viewModel: DriversViewModel

    init(season: String) {
        _viewModel = StateObject(wrappedValue: DriversViewModel(season: season))
    }

    var body: some View {
        List {
            DriversSection(drivers: viewModel.filteredDrivers)
            NationalitySummarySection(nationalityCount: viewModel.nationalityCount)
        }
        .onAppear { viewModel.fetchDrivers() }
        .navigationTitle("Drivers of \(viewModel.season)")
        .searchable(text: $viewModel.searchText)
    }
}
