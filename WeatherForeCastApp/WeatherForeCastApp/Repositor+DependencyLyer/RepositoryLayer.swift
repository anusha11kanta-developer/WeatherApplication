//
//  RepositoryLayer.swift
//  WeatherForeCastApp
//
//  Created by Anusha on 10/19/26.
//

import Foundation
protocol WeatherRepositoryProtocol {
    func fetchCoordinates(city: String) async throws -> GeocodingResponse
    func fetchWeather(lat: Double, lon: Double) async throws -> WeatherResponse
}
final class WeatherRepository: WeatherRepositoryProtocol {

    private let client: NetworkClientProtocol
    private let config: APIConfig

    init(client: NetworkClientProtocol, config: APIConfig) {
        self.client = client
        self.config = config
    }

    func fetchCoordinates(city: String) async throws -> GeocodingResponse {
        guard let request = Endpoint.geocoding(city: city, limit: 1)
            .request(config: config) else {
            throw NetworkError.invalidURL
        }

        return try await client.request(request)
    }

    func fetchWeather(lat: Double, lon: Double) async throws -> WeatherResponse {
        guard let request = Endpoint.weather(lat: lat, lon: lon)
            .request(config: config) else {
            throw NetworkError.invalidURL
        }

        return try await client.request(request)
    }
}
