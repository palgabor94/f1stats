//
//  Driver.swift
//  F1Stats
//
//  Created by Pál Gábor on 26/08/2024.
//

struct Driver: Codable, Identifiable {
    let id: String
    let url: String
    let givenName: String
    let familyName: String
    let dateOfBirth: String
    let nationality: String
    let permanentNumber: String?
    let code: String?
    
    var name: String {
        return "\(givenName) \(familyName)"
    }
    
    var nationalityFlag: String {
            if let countryCode = nationalityToCountryCode[nationality] {
                return countryCode.nationalityFlag
            }
            return nationality
        }
    
    enum CodingKeys: String, CodingKey {
        case id = "driverId"
        case url, givenName, familyName, dateOfBirth, nationality, permanentNumber, code
    }
}

struct DriversResponse: Codable {
    let MRData: DriversMRData
}

struct DriversMRData: Codable {
    let xmlns: String
    let series: String
    let url: String
    let limit: String
    let offset: String
    let total: String
    let DriverTable: DriverTable
}

struct DriverTable: Codable {
    let season: String?
    let driverId: String?
    let Drivers: [Driver]
}

struct WikipediaSearchResponse: Codable {
    struct Query: Codable {
        struct Search: Codable {
            let title: String
        }
        let search: [Search]
    }
    let query: Query
}

struct WikipediaImageResponse: Codable {
    struct Query: Codable {
        struct Page: Codable {
            struct Thumbnail: Codable {
                let source: String
            }
            let thumbnail: Thumbnail?
        }
        let pages: [String: Page]
    }
    let query: Query
}
