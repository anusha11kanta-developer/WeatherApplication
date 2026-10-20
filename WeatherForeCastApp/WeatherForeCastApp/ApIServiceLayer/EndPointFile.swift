//
//  EndPointFile.swift
//  WeatherForeCastApp
//
//  Created by Anusha on 10/19/26.
//

import Foundation
enum APIEnvironment {
    case development
   var baseURL: String {
        switch self {
        case .development:
            return "https://api.openweathermap.org"
        }
    }
}
struct APIConfig {
    let apiKey: String
    let environment: APIEnvironment

    static func live() -> APIConfig {
        APIConfig(
            apiKey: Bundle.main.object(forInfoDictionaryKey: "OPEN_WEATHER_KEY") as? String ?? "",
            environment: .development
        )
    }
}
enum Endpoint {

    case geocoding(city: String, limit: Int)
    case weather(lat: Double, lon: Double)

    func request(config: APIConfig) -> URLRequest? {
        let baseURL = config.environment.baseURL
        print(baseURL)

        switch self {

        case .geocoding(let city, let limit):
            var components = URLComponents(string: "\(baseURL)/geo/1.0/direct")
            components?.queryItems = [
                .init(name: "q", value:"\(city),US"),
                .init(name: "limit", value: "\(limit)"),
                .init(name: "appid", value: config.apiKey)
            ]
            guard let url = components?.url else { return nil }
            print(url)
            print(URLRequest(url: url))
            return URLRequest(url: url)

        case .weather(let lat, let lon):
            var components = URLComponents(string: "\(baseURL)/data/2.5/weather")
            components?.queryItems = [
                .init(name: "lat", value: "\(lat)"),
                .init(name: "lon", value: "\(lon)"),
                .init(name: "appid", value: config.apiKey),
                .init(name: "units", value: "imperial")
            ]
            guard let url = components?.url else { return nil }
            print(url)
            print(URLRequest(url: url))
            return URLRequest(url: url)
        }
        
    }
}
enum ViewState: Equatable {

    case idle
    case loading
    case loaded
    case error(String)
}
struct City: Decodable {
    var id: String {
           "\(name)-\(lat)-\(lon)"
       }
    let name: String
    let lat: Double
    let lon: Double
    let country: String
    let state: String?
}
