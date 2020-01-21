//
//  ChuckNorisAPI.swift
//  DesafioStone
//
//  Created by Marcos Felipe Souza on 25/07/19.
//  Copyright © 2019 Marcos Felipe Souza. All rights reserved.
//

import Foundation
import RxSwift


class ChuckNorrisAPI: BaseAPI, ChuckNorrisAPIType {
    
    var urlSession = URLSession.shared
    
    fileprivate let categoriesEndpoint = "jokes/categories"
    fileprivate let factEndpoint = "jokes/search"
    
    func categories() -> Observable<CategoryResponse> {
        
        guard let urlRequest = request(endpoint: categoriesEndpoint) else { return Observable.empty() }
        
        return urlSession.rx
            .data(request: urlRequest)
            .map(CategoryResponse.init)
    }
    
    func facts(category: CategoryModel?) -> Observable<FactResponse> {
        var query: [String: Any]? = nil
        if let category = category {
            query = ["query": category.value]
        } else {
            query = ["query": "animal"]
        }
        guard let urlRequest = self.request(endpoint: self.factEndpoint, query: query ?? [:]) else {
            return .empty()
        }
        
        return self.send(urlRequest: urlRequest)
    }
    
    private func request(endpoint: String,
                        query: [String: Any] = [:]) -> URLRequest? {
        do {
            let urlBase = ChuckNorrisAPI.Info.baseURL.replacingOccurrences(of: "\\", with: "")
            guard let url = URL(string: urlBase)?.appendingPathComponent(endpoint),
                var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
                    throw ChuckNorrisAPIError.invalidURL(endpoint)
            }
            if query.count > 0 {
                components.queryItems = try query.compactMap { (key, value) in
                    guard let v = value as? CustomStringConvertible else {
                        throw ChuckNorrisAPIError.invalidParameter(key, value)
                    }
                    return URLQueryItem(name: key, value: v.description)
                }
            }
            
            guard let finalURL = components.url else {
                throw ChuckNorrisAPIError.invalidURL(endpoint)
            }
            let request = URLRequest(url: finalURL)
            return request
        } catch {
            return nil
        }
    }
    
}

extension ChuckNorrisAPI {
    struct Info {
        static var baseURL: String {
            return InfoPlist.value(for: "API_BACKEND_URL")
        }
        
        static var domain: String {
            return InfoPlist.value(for: "API_DOMAIN")
        }
    }
}

enum ChuckNorrisAPIError: Error {
    case invalidURL(String)
    case invalidParameter(String, Any)
    case invalidJSON(String)
    case notFound
    case serverFailure
}
