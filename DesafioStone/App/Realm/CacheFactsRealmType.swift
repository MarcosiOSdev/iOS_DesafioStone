//
//  CacheFactsRealmType.swift
//  DesafioStone
//
//  Created by Marcos Felipe Souza on 19/08/19.
//  Copyright © 2019 Marcos Felipe Souza. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

enum CacheFactsRealmError: Error {
    case saveFailed
    case notFoundCache
}


protocol CacheFactsRealmType: AnyObject {
    @discardableResult
    func saveCaches(_ items: [FactModel]) -> Observable<CacheFactsModel>
    
    @discardableResult
    func resetCache() -> Observable<Bool>
    
    @discardableResult
    func fact(on date: Date) -> Observable<CacheFactsModel>
}
