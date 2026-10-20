//
//  NetworkingLayer.swift
//  WeatherForeCastApp
//
//  Created by Anusha on 10/19/26.
//

import Foundation
protocol NetworkClientProtocol {
    func request<T: Decodable>(_ request: URLRequest) async throws -> T
}
final class NetworkClient: NetworkClientProtocol {

    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func request<T: Decodable>(_ request: URLRequest) async throws -> T {

        let (data, response) = try await session.data(for: request)
        print(data,response)

        guard let http = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard (200...299).contains(http.statusCode) else {
            throw NetworkError.serverError
        }

        do {
            
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.decoding
        }
    }
}

enum NetworkError: LocalizedError, Equatable {
    case invalidURL
    case invalidResponse
    case decoding
    case networkUnavailable
    case cityNotFound
    case serverError
    case unknown

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid request."

        case .invalidResponse:
            return "Unable to retrieve weather information."

        case .decoding:
            return "Unable to process server response."

        case .networkUnavailable:
            return "No internet connection. Please check your network."

        case .cityNotFound:
            return "City not found. Please try another city."

        case .serverError:
            return "The server is currently unavailable. Please try again later."

        case .unknown:
            return "Something went wrong. Please try again."
        }
    }
}
