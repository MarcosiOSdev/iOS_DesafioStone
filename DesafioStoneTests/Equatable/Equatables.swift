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
