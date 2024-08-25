//
//  CitySearchResultsTableViewController.swift
//  WeatherApp
//
//  Created by Akshay Reddy on 25/08/24.
//

import UIKit

class CitySearchResultsTableViewController: UITableViewController {

    var filteredCities: [City] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    var onCitySelected: ((City) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CityCell")
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCities.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath)
        let city = filteredCities[indexPath.row]
        cell.textLabel?.text = city.formattedName
        return cell
    }

    // Handle city selection
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCity = filteredCities[indexPath.row]
        onCitySelected?(selectedCity)
        dismiss(animated: true, completion: nil)
    }
}
