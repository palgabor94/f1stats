//
//  DownloadManager.swift
//  F1Stats
//
//  Created by Pál Gábor on 26/08/2024.
//

import Foundation
import Combine

class DownloadManager {
    static let shared = DownloadManager()
    
    func downloadImage(from url: URL) -> AnyPublisher<Data, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
