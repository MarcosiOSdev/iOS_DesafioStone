//
//  Category.swift
//  DesafioStone
//
//  Created by Marcos Felipe Souza on 26/07/19.
//  Copyright © 2019 Marcos Felipe Souza. All rights reserved.
//

import Foundation

class CategoryModel {
    var uid: Int = 0
    var value: String = ""
    
    init(uid: Int, value: String) {
        self.uid = uid
        self.value = value
    }
}

extension CategoryModel {
    static var isEmpty: CategoryModel {        
        return CategoryModel(uid: 0, value: "")
    }
}

struct CategoryResponse: Codable {
    let values: [String]
    
    init(data: Data) {
        guard let mySelf = try? JSONDecoder().decode(CategoryResponse.self, from: data) else {
            self.values = []
            return
        }
        
        self = mySelf
    }
    
    init(_ values: [String]) {
        self.values = values
    }
}


