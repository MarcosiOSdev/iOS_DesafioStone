//
//  ChuckNorisAPI.swift
//  DesafioStone
//
//  Created by Marcos Felipe Souza on 25/07/19.
//  Copyright © 2019 Marcos Felipe Souza. All rights reserved.
//

import Foundation
import RxSwift

class ChuckNorrisAPI {
    
    static let urlSession = URLSession.shared
    
    static fileprivate let categoriesEndpoint = "jokes/categories"

    
    
    static var categories: Observable<[String]> = {
        
        guard let urlRequest = request(endpoint: categoriesEndpoint) else { return Observable.empty() }
        
        return urlSession.rx
            .data(request: urlRequest)
            .map { data -> [String] in
                
                if let strings = try? JSONDecoder().decode([String].self, from: data) {
                    return strings
                }
                return ["Iaaaa... "]
            }
            .catchErrorJustReturn([])
            .share(replay: 1, scope: .forever)
    }()
    
    static func request(endpoint: String,
                        query: [String: Any] = [:]) -> URLRequest? {
        do {
            let urlBase = ChuckNorrisAPI.Info.baseURL.replacingOccurrences(of: "\\", with: "")
            guard let url = URL(string: urlBase)?.appendingPathComponent(endpoint),
                var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
                    throw EOError.invalidURL(endpoint)
            }
            if query.count > 0 {
                components.queryItems = try query.flatMap { (key, value) in
                    guard let v = value as? CustomStringConvertible else {
                        throw EOError.invalidParameter(key, value)
                    }
                    return URLQueryItem(name: key, value: v.description)
                }
            }
            
            guard let finalURL = components.url else {
                throw EOError.invalidURL(endpoint)
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

enum EOError: Error {
    case invalidURL(String)
    case invalidParameter(String, Any)
    case invalidJSON(String)
}
