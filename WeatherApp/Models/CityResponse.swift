//
//  CitiesResponseModel.swift
//  WeatherApp
//
//  Created by Akshay Reddy on 24/08/24.
//

import Foundation

import Foundation

struct City: Codable {
    let name: String
    let lat: Double
    let lon: Double
    let country: String?
    let state: String?
}

extension City {
    var formattedName: String {
        let displayValues: [String] = [name, state, country].compactMap({$0})
        return displayValues.joined(separator: ", ")
    }
}
