//
//  GoogleImage.swift
//  F1Stats
//
//  Created by Pál Gábor on 28/08/2024.
//

import Foundation

struct GoogleSearchResponse: Codable {
    let items: [SearchItem]?
}

struct SearchItem: Codable {
    let pagemap: PageMap?
}

struct PageMap: Codable {
    let cse_image: [CSEImage]?
    let cse_thumbnail: [CSEThumbnail]?
}

struct CSEImage: Codable {
    let src: String
}

struct CSEThumbnail: Codable {
    let src: String
}
