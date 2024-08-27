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

class MockOpenWeatherAPI: OpenWeatherAPIProtocol {
    var fetchWeatherDataResult: Result<WeatherResponse, Error>?
    var fetchCitiesResult: Result<[City], Error>?
    
    func fetchWeatherData(lat: Double, lon: Double) -> AnyPublisher<WeatherResponse, Error> {
        if let result = fetchWeatherDataResult {
            return result.publisher.eraseToAnyPublisher()
        }
        return Fail(error: URLError(.badServerResponse)).eraseToAnyPublisher()
    }
    
    func fetchCities(for query: String) -> AnyPublisher<[City], Error> {
        if let result = fetchCitiesResult {
            return result.publisher.eraseToAnyPublisher()
        }
        return Fail(error: URLError(.badServerResponse)).eraseToAnyPublisher()
    }
}
