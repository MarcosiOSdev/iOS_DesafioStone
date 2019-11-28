//
//  Category.swift
//  DesafioStone
//
//  Created by Marcos Felipe Souza on 26/07/19.
//  Copyright © 2019 Marcos Felipe Souza. All rights reserved.
//

import Foundation
import RxDataSources

class CategoryModel {
    var uid: Int = 0
    var value: String = ""
    
}

extension CategoryModel {
    static var isEmpty: CategoryModel {
        let cat = CategoryModel()
        cat.uid = 0
        cat.value = ""
        return cat
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


