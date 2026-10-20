Open the project in Xcode:
cd WeatherForeCastApp
open WeatherForeCastApp.xcodeproj
Build and run the app on a simulator or a physical device
## USAGE
Launch the app
Enter a city name in the search bar to fetch weather data.
View the weather details, including temperature and description.
Use location services to fetch weather for your current location.
##Testing
The project includes unit tests for the WeatherViewModel and WeatherAPIService. To run the tests:
Open the project in Xcode.
Select the WeatherForeCastAppTests target.
Press Command + U to run all tests.
##Project Structure
WeatherAPIService: Handles API requests to fetch weather and geocoding data.
WeatherViewModel: Manages the app's state and business logic.
MockNetworkClient: A mock implementation of the network client for testing.
WeatherForeCastAppTests: Contains unit tests for the app.
##API Reference
This app uses the OpenWeatherMap API. You need an API key to use the app. Replace the placeholder apiKey in the code with your API key.
Contributions are welcome! Please fork the repository and submit a pull request.


# WeatherForeCastApp

WeatherForeCastApp is an iOS application that provides weather forecasts for cities around the world. It uses the OpenWeatherMap API to fetch weather data and displays it in a user-friendly interface.

## Features

- Search for weather by city name.
- Display current weather conditions, including temperature and description.
- Fetch weather data based on user location.
- Error handling for invalid city names or API failures.

## Requirements

- iOS 15.0+
- Xcode 13.0+
- Swift 5.0+
