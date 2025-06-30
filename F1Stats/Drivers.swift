//
//  Drivers.swift
//  F1Stats
//
//  Created by Pál Gábor on 26/08/2024.
//

struct Driver: Codable {
    let driverId: String
    let permanentNumber: Int
    let code: String
    let url: String
    let givenName: String
    let familyName: String
    let dateOfBirth: String
    let nationality: String
}

struct DriverTable: Codable {
    let season: String
    let drivers: [Driver]
}

struct DriversMRData: Codable {
    let xmlns: String
    let series: String
    let url: String
    let limit: Int
    let offset: Int
    let total: Int
    let driverTable: DriverTable
}
