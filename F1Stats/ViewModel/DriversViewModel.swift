//
//  DriversViewModel.swift
//  F1Stats
//
//  Created by Pál Gábor on 26/08/2024.
//

import Foundation
import Combine

class DriversViewModel: ObservableObject {
    @Published var drivers: [Driver] = []
    @Published var filteredDrivers: [Driver] = []
    @Published var nationalityCount: [String: Int] = [:]
    @Published var searchText: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    let season: String

    init(season: String) {
        self.season = season
        setupSearchSubscription()
    }

    func fetchDrivers() {
        APIManager.shared.fetchDrivers(for: season)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] driversResponse in
                self?.drivers = driversResponse.MRData.DriverTable.Drivers
                self?.filteredDrivers = driversResponse.MRData.DriverTable.Drivers
                self?.updateNationalityCount()
            })
            .store(in: &cancellables)
    }

    private func setupSearchSubscription() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                self?.filterDrivers(with: searchText)
            }
            .store(in: &cancellables)
    }

    private func filterDrivers(with query: String) {
        if query.isEmpty {
            filteredDrivers = drivers
        } else {
            filteredDrivers = drivers.filter { $0.familyName.lowercased().contains(query.lowercased()) }
        }
    }

    private func updateNationalityCount() {
        nationalityCount = Dictionary(grouping: drivers, by: { $0.nationalityFlag })
            .mapValues { $0.count }
    }
}

