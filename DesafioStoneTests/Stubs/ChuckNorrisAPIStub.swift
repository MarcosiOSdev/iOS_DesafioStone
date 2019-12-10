//
//  ChuckNorrisAPIStub.swift
//  DesafioStoneTests
//
//  Created by Marcos Felipe Souza on 29/11/19.
//  Copyright © 2019 Marcos Felipe Souza. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
@testable import DesafioStone

class ChuckNorrisAPIStub: ChuckNorrisAPIType {
    func categories() -> Observable<CategoryResponse> {
        return Observable<CategoryResponse>.of(CategoryResponse(["TESTE", "MOCK"]))
    }
    
    func facts(category: CategoryModel?) -> Observable<FactResponse> {
        
        let facts = [FactResponse.Fact(id: "1", url: "www.1", value: "Ola teste 1", categories: [""]),
                     FactResponse.Fact(id: "2", url: "www.2", value: "Ola teste 2", categories: [""]),
                     FactResponse.Fact(id: "3", url: "www.3", value: "Ola teste 3", categories: ["Sweet"])
                    ]
        let response = FactResponse(total: 3, result: facts)
        
        return Observable<FactResponse>.of(response)
    }
}

class ChuckNorrisAPIEmptyStub: ChuckNorrisAPIStub {
    override func facts(category: CategoryModel?) -> Observable<FactResponse> {
        let response = FactResponse(total: 0, result: [])
        return Observable<FactResponse>.of(response)
    }
}

class ChuckNorrisAPIErrorNetworkStub: ChuckNorrisAPIStub {
    
    override func facts(category: CategoryModel?) -> Observable<FactResponse> {        
        return Observable.create { observer in
            observer.on(.error(RxCocoaURLError.unknown))
            return Disposables.create()
        }
    }
}


//class ChuckNorrisAPIErrorStub: ChuckNorrisAPIStub {
//    override func facts(category: CategoryModel?) -> Observable<FactResponse> {
//        return Observable<FactResponse>.
//    }
//}

enum SomeError: Error {
    case teste
}
