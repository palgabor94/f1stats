//
//  SeasonsView.swift
//  F1Stats
//
//  Created by Pál Gábor on 26/08/2024.
//

import SwiftUI

struct SeasonsView: View {
    @StateObject private var viewModel = SeasonsViewModel()

    var body: some View {
        List(viewModel.seasons, id: \.year) { season in
            SeasonListCell(season: season)
        }
        .onAppear {
            viewModel.fetchSeasons()
        }
        .navigationTitle("Seasons")
    }
}
