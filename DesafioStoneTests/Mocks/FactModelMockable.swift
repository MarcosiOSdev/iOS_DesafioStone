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

extension FactsTableViewCellType {
    
    static var mockFactsBackAPIStub: [FactsTableViewCellType] {
                                
        return [ .normal(factModel: FactModel(id: "1", title: "Ola teste 1", tag: "", url: "www.1")),
                 .normal(factModel: FactModel(id: "2", title: "Ola teste 2", tag: "", url: "www.2")),
                 .normal(factModel: FactModel(id: "3", title: "Ola teste 3", tag: "", url: "www.3"))            
                ]
        
    }
//    var fakeFacts = [FactResponse.Fact(id: "1", url: "www.1", value: "Ola teste 1", categories: [""]),
//     FactResponse.Fact(id: "2", url: "www.2", value: "Ola teste 2", categories: [""]),
//     FactResponse.Fact(id: "3", url: "www.3", value: "Ola teste 3", categories: ["Sweet"])
//    ]
    
    static var mockFactsResult: [FactsTableViewCellType] {
        return [FactsTableViewCellType.normal(factModel: FactModel.mockable),
                FactsTableViewCellType.normal(factModel: FactModel.mockable),
                FactsTableViewCellType.normal(factModel: FactModel.mockable)]
    }
    
    static var mockLoadResult: [FactsTableViewCellType] {
        return [.loading, .loading, .loading]
    }
}
