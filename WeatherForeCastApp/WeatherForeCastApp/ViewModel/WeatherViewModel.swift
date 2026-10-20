//
//  CoordinatoeFile.swift
//  WeatherForeCastApp
//
//  Created by Anusha on 10/19/26.
//
import Combine
import Foundation
import CoreLocation

@MainActor
final class WeatherViewModel: ObservableObject {

    @Published var city = ""
    @Published private(set) var weather: WeatherResponse?
    @Published private(set) var state: ViewState?
    @Published var errorMessage: String?
    @Published var alert: AlertState?
    private let repository: WeatherRepositoryProtocol
     var locationService: LocationService

    init(
        repository: WeatherRepositoryProtocol,
        locationService: LocationService
    ) {
        self.repository = repository
        self.locationService = locationService
        observeLocation()
        onAppear()
    }

    func requestLocationPermission() {
        locationService.requestWhenInUseAuthorization()
    }

func search() async {
    errorMessage = nil
      
    guard city.isValidCityName else {
           alert = .message("Please enter a valid city name.")
           return
       }
    state = .loading

        do {

            let locations = try await repository.fetchCoordinates(city: city)

            guard let first = locations.first else {
                throw NetworkError.cityNotFound
            }

            weather = try await repository.fetchWeather(
                lat: first.lat,
                lon: first.lon
            )

            state = .loaded

        } catch let error as NetworkError {

            errorMessage = error.localizedDescription
            state = .error(error.localizedDescription)

        } catch {

            errorMessage = NetworkError.unknown.localizedDescription
            state = .error(NetworkError.unknown.localizedDescription)
        }
    }

    private func observeLocation() {

        locationService.onAuthorizationChange = { [weak self] status in

            guard let self else { return }

            switch status {

            case .authorizedAlways, .authorizedWhenInUse:
                self.state = .loading   // 🔥 IMPORTANT
                           self.locationService.requestCurrentLocation()
                //self.locationService.requestCurrentLocation()

            case .denied:
                self.errorMessage = "Location permission denied."

            default:
                break
            }
        }

        locationService.onLocationUpdate = { [weak self] coordinate in

            guard let self else { return }

            Task {

                self.state = .loading

                do {

                    self.weather = try await self.repository.fetchWeather(
                        lat: coordinate.latitude,
                        lon: coordinate.longitude
                    )

                    self.state = .loaded

                } catch {
                    self.state = .error(error.localizedDescription)
                }
            }
        }
    }
    func onAppear() {

        switch locationService.authorizationStatus {

        case .notDetermined:

            locationService.requestWhenInUseAuthorization()

        case .authorizedAlways,
             .authorizedWhenInUse:

            locationService.requestCurrentLocation()

        default:
            break
        }
    }
    
}
