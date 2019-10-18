//
//  CacheFacts.swift
//  DesafioStone
//
//  Created by Marcos Felipe Souza on 18/08/19.
//  Copyright © 2019 Marcos Felipe Souza. All rights reserved.
//

import Foundation
import RealmSwift

class CacheFactsModel: Object {
    
    @objc dynamic var lastUpdate:Date = Date();
    let items = List<FactModel>()
    
    static var empty: CacheFactsModel = {
        let model = CacheFactsModel()
        model.lastUpdate = Date()
        model.items.removeAll()
        return model       
    }()
}

