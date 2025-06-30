//
//  SeasonsViewModel.swift
//  F1Stats
//
//  Created by Pál Gábor on 26/08/2024.
//

import Foundation
import Combine

class SeasonsViewModel: ObservableObject {
    @Published var seasons: [Season] = []
    private var cancellables = Set<AnyCancellable>()

    func fetchSeasons() {
        APIManager.shared.fetchSeasons()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] seasonsResponse in
                self?.seasons = seasonsResponse.mrData.seasonTable.seasons
            })
            .store(in: &cancellables)
    }
}

