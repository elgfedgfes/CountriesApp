//
//  URLsHelper.swift
//  CountriesApp
//
//  Created by Luis Fernando Sánchez Palma on 08/05/24.
//

import Foundation

enum APIBasePath: String {
    case base = "https://restcountries.com/v3.1/"
}

enum Endpoint: String {
    case allCountries = "all"
}

class URLsHelper {
    static let AllCountries = (APIBasePath.base.rawValue + Endpoint.allCountries.rawValue)
    
    func appendNameQueryParameter(url: String, name: String) -> String {
        guard var urlComponents = URLComponents(string: url + "/") else {
            return url
        }
        urlComponents.queryItems = [URLQueryItem(name: "name", value: name)]
        guard let nonNilURL = urlComponents.url else {
            return url
        }
        return nonNilURL.absoluteString
    }
}
