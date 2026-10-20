//
//  DependencyInjectionFile.swift
//  WeatherForeCastApp
//
//  Created by Anusha on 10/19/26.
//

final class DIContainer {

    let config: APIConfig
    let networkClient: NetworkClientProtocol
    let weatherRepository: WeatherRepositoryProtocol
    let locationService = DefaultLocationService()

    init() {
        self.config = .live()
        self.networkClient = NetworkClient()
        self.weatherRepository = WeatherRepository(
            client: networkClient,
            config: config
        )
    }

    func makeWeatherViewModel() -> WeatherViewModel {
        WeatherViewModel(repository: weatherRepository, locationService: locationService)
    }
//    func makeSearchCoordinator() -> SearchCoordinator {
//        SearchCoordinator(container: self)
//    }
}



      


