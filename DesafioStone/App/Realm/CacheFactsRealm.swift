//
//  CacheFactsRealm.swift
//  DesafioStone
//
//  Created by Marcos Felipe Souza on 18/08/19.
//  Copyright © 2019 Marcos Felipe Souza. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift
import RxRealm

class CacheFactsRealm: CacheFactsRealmType {
    
    fileprivate func withRealm<T>(_ operation: String, action: (Realm) throws -> T) -> T? {
        do {
            let realm = try Realm()
            return try action(realm)
        } catch let err {
            print("Failed \(operation) realm with error: \(err)")
            return nil
        }
    }
    
    
    func saveCaches(_ items: [FactModel]) -> Observable<CacheFactsModel> {
        let result = withRealm("save dates") { (realm) -> Observable<CacheFactsModel> in
            let cache = CacheFactsModel()
            cache.lastUpdate = Date()
            
            try realm.write {
                items.forEach { cache.items.append($0) }
                realm.add(cache)
            }
            return .just(cache)
        }
        return result ?? .error(CacheFactsRealmError.saveFailed)
    }
    
    func resetCache() -> Observable<Bool> {
        let result = withRealm("Reset all caches") { realm -> Observable<Bool> in
            let cache = realm.objects(CacheFactsModel.self)
            if cache.count > 0 {
                realm.delete(cache)
            }
            return .just(true)
        }
        
        return result ?? .just(false)
    }
    
    func fact(on date: Date) -> Observable<CacheFactsModel> {
        let result = withRealm("getting cache with date :\(date)") { realm -> Observable<CacheFactsModel> in
            let caches = realm.objects(CacheFactsModel.self)
            if caches.count == 0 {
                return .just(CacheFactsModel.empty)
            }
            let withDate = caches.filter {
                let order = Calendar.current.compare(date, to: $0.lastUpdate, toGranularity: .day)
                return order == .orderedSame
            }
            
            let obs:[CacheFactsModel] = withDate.elements.map { objct -> CacheFactsModel in
                return objct
            }
            return Observable.from(obs)
        }
        return result ?? .error(CacheFactsRealmError.notFoundCache)
    }
    
    
}
