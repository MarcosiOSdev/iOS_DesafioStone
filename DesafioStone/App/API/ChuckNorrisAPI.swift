//
//  ChuckNorisAPI.swift
//  DesafioStone
//
//  Created by Marcos Felipe Souza on 25/07/19.
//  Copyright © 2019 Marcos Felipe Souza. All rights reserved.
//

import Foundation


class ChuckNorrisAPI {
    let baseURL = ChuckNorrisAPI.Info.baseURL.replacingOccurrences(of: "\\", with: "")

    
    
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
