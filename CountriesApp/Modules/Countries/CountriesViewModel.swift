//
//  CountriesViewModel.swift
//  CountriesApp
//
//  Created by Luis Fernando Sánchez Palma on 08/05/24.
//

import Foundation

protocol CountriesViewModelDelegate: AnyObject {
    func notifyNotFoundCountries()
}

class CountriesViewModel {
    var networkManager = NetworkManager()
    weak var delegate: CountriesViewModelDelegate?
    var refreshData = { () -> () in}
    var countries: [CountriesModel] = [] {
        didSet {
            refreshData()
        }
    }
    
    func getCountries() {
        let url = URLsHelper.allCountries
        makeCountriesRequest(urlRequest: url)
    }
    
    
    private func makeCountriesRequest(urlRequest: String) {
        networkManager.request(url: urlRequest, method: .get, responseType: [CountriesModelResponse].self) { [weak self] modelResponse in
            let responseCountries = modelResponse.map {
                CountriesModel(nameCommon: $0.name?.common, nameOfficial: $0.name?.official, capital: $0.capital, Currencies: $0.currencies, flagURL: $0.flags?.png, mapURL: $0.maps?.googleMaps)
            }
            self?.countries = responseCountries
        } failure: { [weak self] errorResponse in
            if errorResponse.message == "not found" {
                self?.delegate?.notifyNotFoundCountries()
            } else {
                print("Error \(errorResponse)")
            }
        }
    }
}
