@testable import WeatherForeCastApp
import CoreLocation
import Foundation
enum WeatherMockFactory {

    static func sampleWeatherResponse() -> WeatherResponse {
        WeatherResponse(
            coord: Coord(lon: 77.1025, lat: 28.7041),
            weather: [
                Weather(
                    id: 800,
                    main: "Clear",
                    description: "clear sky",
                    icon: "01d"
                )
            ],
            base: "stations",
            main: MainWeather(
                temp: 25.0,
                feelsLike: 27.0,
                tempMin: 24.0,
                tempMax: 28.0,
                pressure: 1012,
                humidity: 60,
                seaLevel: nil,
                grndLevel: nil
            ),
            visibility: 10000,
            wind: Wind(
                speed: 3.5,
                deg: 200,
                gust: nil
            ),
            clouds: Clouds(all: 0),
            dt: 1700000000,
            sys: Sys(
                type: 1,
                id: 1234,
                country: "IN",
                sunrise: 1699940000,
                sunset: 1699980000
            ),
            timezone: 19800,
            id: 1273294,
            name: "Delhi",
            cod: 200
        )
    }
}
extension WeatherResponse {

    static func mock() -> WeatherResponse {
        WeatherMockFactory.sampleWeatherResponse()
    }
}

enum GeocodingMockFactory {

    static func sample() -> GeocodingResponse {
        return [
            GeocodingLocation(
                name: "Delhi",
                localNames: ["en": "Delhi"],
                lat: 28.7041,
                lon: 77.1025,
                country: "IN",
                state: "Delhi"
            )
        ]
    }
}

final class MockWeatherRepository: WeatherRepositoryProtocol {
    var shouldFail = false
    var fetchCoordinatesCalled = false
    var fetchWeatherCalled = false
    var mockCoordinateResponse = GeocodingMockFactory.sample()
    func fetchCoordinates(city: String) async throws -> GeocodingResponse {
        fetchCoordinatesCalled = true

        if shouldFail {
            throw URLError(.badServerResponse)
        }

        return GeocodingMockFactory.sample()
    }

    func fetchWeather(lat: Double, lon: Double) async throws -> WeatherResponse {
        fetchWeatherCalled = true

        if shouldFail {
            throw URLError(.badServerResponse)
        }

        return WeatherMockFactory.sampleWeatherResponse()
    }
}

final class MockLocationService: LocationService {

    var authorizationStatus: CLAuthorizationStatus = .notDetermined

    var onLocationUpdate: ((CLLocationCoordinate2D) -> Void)?
    var onAuthorizationChange: ((CLAuthorizationStatus) -> Void)?

    var didRequestPermission = false
    var didRequestLocation = false

    func requestWhenInUseAuthorization() {
        didRequestPermission = true
        authorizationStatus = .authorizedWhenInUse
        onAuthorizationChange?(.authorizedWhenInUse)
    }

    func requestCurrentLocation() {
        didRequestLocation = true
        onLocationUpdate?(
            CLLocationCoordinate2D(latitude: 10, longitude: 20)
        )
    }
}


