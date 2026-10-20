//
//  WeatherViewModelTests.swift
//  WeatherForeCastAppTests
//
//  Created by Anusha on 10/19/26.
//
import XCTest
@testable import WeatherForeCastApp

@MainActor
final class WeatherViewModelTests: XCTestCase {
var mockWeatherResponse = WeatherMockFactory.sampleWeatherResponse()
    var viewModel: WeatherViewModel!
    var repository: MockWeatherRepository!
    var locationService: MockLocationService!
    override func setUp() {
        super.setUp()

        repository = MockWeatherRepository()
        locationService = MockLocationService()

        viewModel = WeatherViewModel(
            repository: repository,
            locationService: locationService
        )
    }

    override func tearDown() {
        viewModel = nil
        repository = nil
        locationService = nil
        super.tearDown()
    }

    func test_weather_success() async {

        viewModel.city = "Texas"

        await viewModel.search()

        XCTAssertEqual(viewModel.state, .loaded)
        XCTAssertEqual(repository.fetchCoordinatesCalled, true)
        XCTAssertEqual(repository.fetchWeatherCalled, true)
    }
    func test_weather_api_failure_sets_error_state() async {
        
        repository.shouldFail = true

        viewModel.city = "Texas"

        await viewModel.search()

        if case .error(let message) = viewModel.state {
            XCTAssertFalse(message.isEmpty)
        } else {
            XCTFail("Expected error state")
        }
    }
    func test_weather_invalid_city_sets_error_state() async {
          viewModel.city = "InvalidCity"
          repository.shouldFail = true
          await viewModel.search()
          if case .error(let message) = viewModel.state {
              XCTAssertFalse(message.isEmpty)
          } else {
              XCTFail("Expected error state")
          }
      }
  
  }


