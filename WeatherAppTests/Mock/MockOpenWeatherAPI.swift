//
//  MockOpenWeatherAPI.swift
//  WeatherAppTests
//
//  Created by Akshay Reddy on 26/08/24.
//

import Foundation
import Combine
import CoreLocation
import UIKit
import XCTest
@testable import WeatherApp

// Mock for OpenWeatherAPIProtocol
class MockOpenWeatherAPI: OpenWeatherAPIProtocol {
    var weatherData: WeatherResponse?
    var citiesData: [City] = []
    var shouldReturnError = false
    
    func fetchWeatherData(lat: Double, lon: Double) -> AnyPublisher<WeatherResponse, Error> {
        if shouldReturnError {
            return Fail(error: URLError(.badServerResponse))
                .eraseToAnyPublisher()
        } else if let weatherData = weatherData {
            return Just(weatherData)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else {
            return Empty(completeImmediately: true).eraseToAnyPublisher()
        }
    }
    
    func fetchCities(for query: String) -> AnyPublisher<[City], Error> {
        if shouldReturnError {
            return Fail(error: URLError(.badServerResponse))
                .eraseToAnyPublisher()
        } else {
            return Just(citiesData)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
}

// Mock for LocationManager
class MockLocationManager: LocationManager {
    var requestLocationCalled = false

    override func requestLocation() {
        requestLocationCalled = true
    }
}

