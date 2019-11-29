//
//  FactModelMockable.swift
//  DesafioStoneTests
//
//  Created by Marcos Felipe Souza on 29/11/19.
//  Copyright © 2019 Marcos Felipe Souza. All rights reserved.
//

@testable import DesafioStone
import Foundation

extension FactModel {
    static var mockable: FactModel {
        let model = FactModel()
        model.id = "1"
        model.title = "Lets Test"
        model.tag = "UNCATEGORIZED"
        model.url = "www.kd.imagem"
        return model
    }
}
