//
//  Equatables.swift
//  DesafioStoneTests
//
//  Created by Marcos Felipe Souza on 30/11/19.
//  Copyright © 2019 Marcos Felipe Souza. All rights reserved.
//

import Foundation
@testable import DesafioStone

extension FactsTableViewCellType: Equatable {
    public static func == (lhs: FactsTableViewCellType, rhs: FactsTableViewCellType) -> Bool {
        switch (lhs, rhs) {
        case (.normal(factModel: _), .normal(factModel: _)):
            return true
        case (.error(message: _), .error(message: _)):
            return true
        case (.empty, .empty):
            return true
        default:
            return false
        }
    }
}

extension Scene: Equatable {
    public static func == (lhs: Scene, rhs: Scene) -> Bool {        
        switch (lhs, rhs) {
        case (.facts, .facts): return true
        case (.searchCategory, .searchCategory): return true
        case (.none, .none): return true
        case (.sharedLink(title: _, link: _, completion: _),
              .sharedLink(title: _, link: _, completion: _)): return true
        default: return false
        }
    }
}

extension CategoryModel: Equatable {
    public static func == (lhs: CategoryModel, rhs: CategoryModel) -> Bool {
        return lhs.uid == rhs.uid && lhs.value == rhs.value
    }
    
    
}
