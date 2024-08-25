//
//  WeatherViewModelTests.swift
//  WeatherAppTests
//
//  Created by Akshay Reddy on 26/08/24.
//

import XCTest
import Combine
@testable import WeatherApp

class WeatherViewModelTests: XCTestCase {
    
    var viewModel: WeatherViewModel!
    var mockOpenWeatherAPI: MockOpenWeatherAPI!
    var mockLocationManager: MockLocationManager!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockOpenWeatherAPI = MockOpenWeatherAPI()
        mockLocationManager = MockLocationManager()
        viewModel = WeatherViewModel(openweather: mockOpenWeatherAPI, locationManager: mockLocationManager)
        cancellables = []
    }

    override func tearDown() {
        viewModel = nil
        mockOpenWeatherAPI = nil
        mockLocationManager = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testFetchWeatherDataSuccess() {
        // Given
        let city = City(name: "San Francisco",
                        lat: 37.7749,
                        lon: -122.4194,
                        country: "US",
                        state: "California")
        
        let weatherResponse = WeatherResponse(
            coord: Coordinates(lon: -122.4194, lat: 37.7749),
            weather: [Weather(id: 800,
                              main: "Clear",
                              description: "clear sky",
                              icon: "01d")],
            main: MainWeatherData(temp: 68.0,
                                  feelsLike: 68.0,
                                  tempMin: 65.0,
                                  tempMax: 70.0,
                                  pressure: 1013,
                                  humidity: 77),
            name: "San Francisco"
        )

        mockOpenWeatherAPI.weatherData = weatherResponse
        
        // When
        viewModel.fetchWeatherData(for: city)
        
        // Then
        let expectation = XCTestExpectation(description: "Fetch weather data successfully")
        viewModel.$temperature
            .sink { temperature in
                XCTAssertEqual(temperature, "68.0°")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchWeatherDataFailure() {
        // Given
        let city = City(name: "San Francisco", lat: 37.7749, lon: -122.4194, country: "US", state: "California")
        mockOpenWeatherAPI.shouldReturnError = true
        
        // When
        viewModel.fetchWeatherData(for: city)
        
        // Then
        let expectation = XCTestExpectation(description: "Fetch weather data failure")
        viewModel.$errorMessage
            .sink { errorMessage in
                XCTAssertEqual(errorMessage, "Failed to fetch weather data")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchCitiesSuccess() {
        // Given
        let cities = [
            City(name: "San Francisco", lat: 37.7749, lon: -122.4194, country: "US", state: "California"),
            City(name: "Los Angeles", lat: 34.0522, lon: -118.2437, country: "US", state: "California")
        ]
        mockOpenWeatherAPI.citiesData = cities
        
        // When
        viewModel.fetchCities(for: "San Francisco")
        
        // Then
        let expectation = XCTestExpectation(description: "Fetch cities successfully")
        viewModel.$citiesSearchResults
            .sink { citiesSearchResults in
                XCTAssertEqual(citiesSearchResults.count, 2)
                XCTAssertEqual(citiesSearchResults.first?.name, "San Francisco")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
}

