//
//  APIManager.swift
//  F1Stats
//
//  Created by Pál Gábor on 26/08/2024.
//

import Foundation
import Combine
import UIKit

// MARK: - APIManager errors
enum APIError: Error, LocalizedError {
    case invalidURL
    case noData
    case driverNotFound
    case decodingError(Error)
    case networkError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case .driverNotFound:
            return "Driver not found"
        case .decodingError(let error):
            return "Decoding failed: \(error.localizedDescription)"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        }
    }
}

class APIManager {
    static let shared = APIManager()
    private init() {}
    
    private let baseURL = "https://api.jolpi.ca/ergast/f1"
    private let session = URLSession.shared
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Image cache
    private let imageCache = NSCache<NSString, UIImage>()
    
    // MARK: - Generic network request method
    private func performRequest<T: Decodable>(
        url: URL,
        responseType: T.Type,
        decoder: JSONDecoder = JSONDecoder()
    ) -> AnyPublisher<T, APIError> {
        return session.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: responseType, decoder: decoder)
            .mapError { error in
                if error is DecodingError {
                    return APIError.decodingError(error)
                } else {
                    return APIError.networkError(error)
                }
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: - F1 API Methods
    func fetchSeasons() -> AnyPublisher<FormulaOneSeasonsResponse, APIError> {
        guard let url = URL(string: "\(baseURL)/seasons.json?limit=1000") else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }
        
        return performRequest(url: url, responseType: FormulaOneSeasonsResponse.self)
            .map { response in
                let sortedSeasons = response.mrData.seasonTable.seasons
                    .sorted { Int($0.year) ?? 0 < Int($1.year) ?? 0 }
                
                let last30Seasons = Array(sortedSeasons.suffix(30))
                
                let newSeasonTable = SeasonTable(seasons: last30Seasons)
                
                let newMRData = MRData(
                    xmlns: response.mrData.xmlns,
                    series: response.mrData.series,
                    url: response.mrData.url,
                    limit: "30",
                    offset: response.mrData.offset,
                    total: "30",
                    seasonTable: newSeasonTable
                )
                
                return FormulaOneSeasonsResponse(mrData: newMRData)
            }
            .eraseToAnyPublisher()
    }
    
    func fetchDrivers(for season: String) -> AnyPublisher<DriversResponse, APIError> {
        guard let url = URL(string: "\(baseURL)/\(season)/drivers.json") else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }
        
        print("Fetching drivers for season: \(season) with URL: \(url)")
        
        return performRequest(url: url, responseType: DriversResponse.self)
            .handleEvents(
                receiveOutput: { _ in print("Successfully fetched drivers for season \(season)") },
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        print("Failed to fetch drivers: \(error.localizedDescription)")
                    }
                }
            )
            .eraseToAnyPublisher()
    }
    
    func fetchDriverDetails(driverId: String) -> AnyPublisher<Driver, APIError> {
        guard let url = URL(string: "\(baseURL)/drivers/\(driverId).json") else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }
        
        return performRequest(url: url, responseType: DriversResponse.self)
            .tryMap { response -> Driver in
                guard let firstDriver = response.MRData.DriverTable.Drivers.first else {
                    throw APIError.driverNotFound
                }
                return firstDriver
            }
            .mapError { error -> APIError in
                if let apiError = error as? APIError {
                    return apiError
                } else {
                    return APIError.networkError(error)
                }
            }
            .handleEvents(
                receiveOutput: { driver in print("Successfully fetched driver: \(driver.givenName) \(driver.familyName)") },
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        print("Failed to fetch driver details: \(error.localizedDescription)")
                    }
                }
            )
            .eraseToAnyPublisher()
    }
    
    // MARK: - Image fetching with caching
    func fetchDriverImage(for driverName: String) -> AnyPublisher<UIImage?, Never> {

        let cacheKey = NSString(string: driverName)
        if let cachedImage = imageCache.object(forKey: cacheKey) {
            return Just(cachedImage).eraseToAnyPublisher()
        }
        
        return searchWikipediaImage(for: driverName)
            .handleEvents(receiveOutput: { [weak self] image in
                if let image = image {
                    self?.imageCache.setObject(image, forKey: cacheKey)
                }
            })
            .eraseToAnyPublisher()
    }
    
    private func searchWikipediaImage(for driverName: String) -> AnyPublisher<UIImage?, Never> {
        guard let searchURL = createWikipediaSearchURL(for: driverName) else {
            return Just(nil).eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: searchURL)
            .map(\.data)
            .decode(type: WikipediaSearchResponse.self, decoder: JSONDecoder())
            .compactMap { $0.query.search.first?.title }
            .flatMap { [weak self] pageTitle -> AnyPublisher<UIImage?, Never> in
                self?.fetchImageFromWikipediaPage(pageTitle: pageTitle) ?? Just(nil).eraseToAnyPublisher()
            }
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }
    
    private func createWikipediaSearchURL(for driverName: String) -> URL? {
        let searchQuery = "\(driverName) Formula 1 driver" // Pontosabb keresés
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let searchURLString = "https://en.wikipedia.org/w/api.php?action=query&list=search&srsearch=\(searchQuery)&format=json&srlimit=1"
        return URL(string: searchURLString)
    }
    
    private func fetchImageFromWikipediaPage(pageTitle: String) -> AnyPublisher<UIImage?, Never> {
        guard let imageURL = createWikipediaImageURL(for: pageTitle) else {
            return Just(nil).eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: imageURL)
            .map(\.data)
            .decode(type: WikipediaImageResponse.self, decoder: JSONDecoder())
            .compactMap { response in
                response.query.pages.values.first?.thumbnail?.source
            }
            .compactMap { URL(string: $0) }
            .flatMap { [weak self] imageUrl -> AnyPublisher<UIImage?, Never> in
                self?.downloadImage(from: imageUrl) ?? Just(nil).eraseToAnyPublisher()
            }
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }
    
    private func createWikipediaImageURL(for pageTitle: String) -> URL? {
        let titleEncoded = pageTitle.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let imageURLString = "https://en.wikipedia.org/w/api.php?action=query&titles=\(titleEncoded)&prop=pageimages&format=json&pithumbsize=500&pilicense=any"
        return URL(string: imageURLString)
    }
    
    private func downloadImage(from url: URL) -> AnyPublisher<UIImage?, Never> {
        return session.dataTaskPublisher(for: url)
            .map { data, _ in UIImage(data: data) }
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Cache management
    func clearImageCache() {
        imageCache.removeAllObjects()
    }
    
    func getCacheSize() -> Int {
        return imageCache.totalCostLimit
    }
}
