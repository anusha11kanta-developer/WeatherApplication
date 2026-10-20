//
//  SearchScreen.swift
//  WeatherForeCastApp
//
//  Created by Anusha on 10/19/26.
//

import Foundation
import SwiftUI

struct SearchView: View {

    @StateObject private var viewModel: WeatherViewModel

    init(viewModel: WeatherViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 16) {
            TextField("Enter city", text: $viewModel.city)
                .textFieldStyle(.roundedBorder)
                .accessibilityLabel("City")
                .accessibilityHint("Enter a city name to search for weather")
                .padding()

            Button("Get Weather") {
                Task {
                    await viewModel.search()
                }
            }
            .accessibilityLabel("Search Weather")
            .accessibilityHint("Searches weather for the entered city")
            if let weather = viewModel.weather {
                WeatherCardView(weather: weather)
            }

            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
            }
        }
        .alert(item: $viewModel.alert) { alert in
            switch alert {
            case .message(let text):
                return Alert(
                    title: Text("Weather"),
                    message: Text(text),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .onAppear {
            viewModel.requestLocationPermission()
        }
        
    }
}

