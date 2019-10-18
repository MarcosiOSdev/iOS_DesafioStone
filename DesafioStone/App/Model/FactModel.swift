//
//  QueryModel.swift
//  DesafioStone
//
//  Created by Marcos Felipe Souza on 26/07/19.
//  Copyright © 2019 Marcos Felipe Souza. All rights reserved.
//

import Foundation
import RealmSwift

class FactModel: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var tag: String = ""
    @objc dynamic var url: String = ""
    @objc dynamic var font: UIFont?
    
    @objc dynamic var owned: CacheFactsModel?
    
    func setModel(by fact: FactResponse.Fact) {
        self.id = fact.id
        self.url = fact.url
        self.title = fact.value
        
        if fact.categories.count > 0 {
            self.tag = fact.categories.joined(separator: ",")
        }
    }
    
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["font"]
    }
    
    static var empty: FactModel {
        let factModel = FactModel()
        factModel.id = "0"
        factModel.title = "Empty"
        factModel.tag = "Doesnt have"
        factModel.url = "http..."
        factModel.font = UIFont.systemFont(ofSize: 16)
        return factModel
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
