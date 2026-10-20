//
//  WeatherCardView.swift
//  WeatherForeCastApp
//
//  Created by Anusha on 10/19/26.
//

import Foundation
import SwiftUI
struct WeatherCardView: View {

    let weather: WeatherResponse

    var body: some View {
        ViewThatFits {
            horizontalLayout
            verticalLayout
        }
        .padding()
    }

    private var verticalLayout: some View {
        VStack(spacing: 16) {
            weatherContent
        }
    }

    private var horizontalLayout: some View {
        HStack(spacing: 24) {
            weatherContent
        }
    }

    @ViewBuilder
    private var weatherContent: some View {
        Text(weather.name)
            .font(.title)
            .bold()

        AsyncWeatherIcon(icon: weather.weather.first?.icon)

        Text("\(Int(weather.main.temp))°C")
            .font(.system(.largeTitle, weight: .bold))

        Text(weather.weather.first?.description.capitalized ?? "")

        HStack {
            WeatherInfoItem(
                title: "Feels Like",
                value: "\(Int(weather.main.feelsLike))°"
            )

            WeatherInfoItem(
                title: "Humidity",
                value: "\(weather.main.humidity)%"
            )
        }
    }
}


struct WeatherInfoItem: View {

    let title: String
    let value: String

    var body: some View {

        VStack(spacing: 4) {

            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(1)
                .minimumScaleFactor(0.7)

            Text(value)
                .font(.headline)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .padding(.horizontal, 10)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.7))
        )
        
    }
}


struct AsyncWeatherIcon: View {

    let icon: String?

    var body: some View {

        Group {
            if let icon,
               let url = URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png") {

                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }

            } else {
                Image(systemName: "cloud")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.gray)
            }
        }
        .frame(maxWidth: .infinity)
        .clipped()
    }
}
