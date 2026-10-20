//
//  WeatherForeCastAppApp.swift
//  WeatherForeCastApp
//
//  Created by Anusha on 10/19/26.
//

import SwiftUI

@main
struct WeatherForecastApp: App {

    private let container = DIContainer()

    var body: some Scene {
        WindowGroup {
            SearchView(
                viewModel: container.makeWeatherViewModel()
            )
        }
    }
}
