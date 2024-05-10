//
//  SearchCountriesViewModel.swift
//  CountriesApp
//
//  Created by Luis Fernando Sánchez Palma on 08/05/24.
//

import Foundation

protocol SearchCountriesViewModelDelegate: AnyObject {
    func notifyNotFoundCountries()
}

class SearchCountriesViewModel {
    var networkManager = NetworkManager()
    private let dataManager = CoreDataManager()
    weak var delegate: SearchCountriesViewModelDelegate?
    var refreshData = { () -> () in}
    var countries: [CountriesModel] = [] {
        didSet {
            refreshData()
        }
    }
    var resentSearchResult: [String] = [] {
        didSet {
            refreshData()
        }
    }
    
    func getCountries() {
        let url = URLsHelper.allCountries
        makeCountriesRequest(urlRequest: url)
    }
    
    func getFilterCountries(searchText: String) {
        let filterUrl = URLsHelper().appendNameQueryParameter(url: URLsHelper.namedCountries, name: searchText)
        makeCountriesRequest(urlRequest: filterUrl)
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
    
    func saveResentSearch(name: String) {
        if !resentSearchResult.contains(name) {
            dataManager.RecentSearchPOST(name: name) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(_):
                        print("succes: name saved")
                    case .failure(let error):
                        print("error: \(error)")
                    }
                }
            }
        }
    }
    
    func fetchResentSearch() {
        dataManager.RecentSearchGET { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let responseData):
                    self?.resentSearchResult = responseData
                case .failure(let error):
                    print("error: \(error)")
                }
            }
        }
    }
    
}
