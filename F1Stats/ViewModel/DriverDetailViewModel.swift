//
//  DriverDetailViewModel.swift
//  F1Stats
//
//  Created by Pál Gábor on 26/08/2024.
//

import Foundation
import Combine
import UIKit

class DriverDetailViewModel: ObservableObject {
    @Published var driver: Driver?
    @Published var driverImage: UIImage?
    private var cancellables = Set<AnyCancellable>()
    private var driverId: String
    
    init(driverId: String) {
        self.driverId = driverId
        fetchDriverDetails()
    }
    
    func fetchDriverDetails() {
        APIManager.shared.fetchDriverDetails(driverId: driverId)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] Driver in
                self?.driver = Driver
                self?.fetchDriverImage(for: self?.driver?.name ?? "")
            })
            .store(in: &cancellables)
    }
    
    private func fetchDriverImage(for driverName: String) {
        APIManager.shared.fetchDriverImage(for: driverName)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                self?.driverImage = image
            }
            .store(in: &cancellables)
    }
}

