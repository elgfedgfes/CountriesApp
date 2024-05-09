//
//  URLsHelper.swift
//  CountriesApp
//
//  Created by Luis Fernando Sánchez Palma on 08/05/24.
//

import Foundation

enum APIBasePath: String {
    case base = "https://restcountries.com/v3.1"
}

enum Endpoint: String {
    case allCountries = "/all"
    case nameCountries = "/name"
}

class URLsHelper {
    static let allCountries = (APIBasePath.base.rawValue + Endpoint.allCountries.rawValue)
    static let namedCountries = (APIBasePath.base.rawValue + Endpoint.nameCountries.rawValue)
    
    func appendNameQueryParameter(url: String, name: String) -> String {
        // MARK: - FULL NAME SEARCH
//        guard var urlComponents = URLComponents(string: url + "/\(name)") else {
//            return url
//        }
//        urlComponents.queryItems = [URLQueryItem(name: "fullText", value: "true")]
//        guard let nonNilURL = urlComponents.url else {
//            return url
//        }
//        return nonNilURL.absoluteString
        
        // MARK: - NAME SEARCH
        return url + "/" + name
    }
}
