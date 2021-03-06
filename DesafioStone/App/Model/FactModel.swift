//
//  QueryModel.swift
//  DesafioStone
//
//  Created by Marcos Felipe Souza on 26/07/19.
//  Copyright © 2019 Marcos Felipe Souza. All rights reserved.
//

import Foundation

class FactModel {
    var id: String = ""
    var title: String = ""
    var tag: String = ""
    var url: String = ""
    
    init(id: String, title: String, tag: String, url: String) {
        self.id = id
        self.title = title
        self.tag = tag
        self.url = url
    }
    
    init() {}
    
    func setModel(by fact: FactResponse.Fact) {
        self.id = fact.id
        self.url = fact.url
        self.title = fact.value
        
        if fact.categories.count > 0 {
            self.tag = fact.categories.map{ $0.uppercased() }.joined(separator: ",")
        }
    }
    
    static var empty: FactModel {
        return FactModel(id: "0", title: "Empty", tag: "Doesnt have", url: "http...")
    }
    
}
extension FactModel: Equatable {
    static func == (lhs: FactModel, rhs: FactModel) -> Bool {
        return lhs.id == rhs.id
            && lhs.title == rhs.title
            && lhs.tag == rhs.tag
            && lhs.url == rhs.url
    }
}

struct FactResponse: Codable {
    let total: Int
    let result: [Fact]
    
    init(data: Data) {
        guard let mySelf = try? JSONDecoder().decode(FactResponse.self, from: data) else {
            self.total = 0
            self.result = []
            print("Não possível realizar o DECODER")
            return
        }
        self = mySelf
    }
    
    init(total: Int, result: [Fact]) {
        self.total = total
        self.result = result
    }
    
    static var empty: FactResponse {
        return FactResponse(total: 0, result: [])
    }
    
    // MARK: - Result
    struct Fact: Codable {
        let id: String
        let url: String
        let value: String
        let categories: [String]
        
        enum CodingKeys: String, CodingKey {
            case id
            case url, value, categories
        }
    }
}
