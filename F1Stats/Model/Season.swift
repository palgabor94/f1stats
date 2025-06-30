//
//  Seasons.swift
//  F1Stats
//
//  Created by Pál Gábor on 26/08/2024.
//

import Foundation

struct FormulaOneSeasonsResponse: Codable {
    let mrData: MRData

    enum CodingKeys: String, CodingKey {
        case mrData = "MRData"
    }
}

struct MRData: Codable {
    let xmlns: String
    let series: String
    let url: String
    let limit: String
    let offset: String
    let total: String
    let seasonTable: SeasonTable

    enum CodingKeys: String, CodingKey {
        case xmlns
        case series
        case url
        case limit
        case offset
        case total
        case seasonTable = "SeasonTable"
    }
}

struct SeasonTable: Codable {
    let seasons: [Season]

    enum CodingKeys: String, CodingKey {
        case seasons = "Seasons"
    }
}

struct Season: Codable {
    let year: String
    let wikipediaURL: String

    enum CodingKeys: String, CodingKey {
        case year = "season"
        case wikipediaURL = "url"
    }
}

