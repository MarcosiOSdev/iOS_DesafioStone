//
//  FactViewModel.swift
//  DesafioStone
//
//  Created by Marcos Felipe Souza on 24/07/19.
//  Copyright © 2019 Marcos Felipe Souza. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources
import Action

//typealias FactSection = AnimatableSectionModel<String, FactModel>

//MARK: List of Variables
class FactsViewModel {
    private let chuckNorrisAPI: ChuckNorrisAPIType
    private let coordinator: CoordinatorType
    private let cacheFactsRealm: CacheFactsRealmType
    
    var bag = DisposeBag()
    
    
    
    var factsByFecth = BehaviorSubject<[FactModel]>(value: [])
    
    //MARK: Outputs
    var facts = BehaviorSubject<[FactModel]> (value: [])
    
    var title: Observable<String> {
        return Observable<String>.of(StringText.sharing.text(by: .titleFactScene))
    }
    
    //MARK: Input
    lazy var searchViewButtonTapped: Action<Void, Void> = { this in
        return Action { [weak self] element in
            print("Vai pesquisar ... tem que fazer")
            //            self?.coordinator.transition(to: .searchView, type: .push)
            
            this.facts.onNext([])
            
            return Observable.empty()
        }
    }(self)
    var categoryForSearch = BehaviorSubject<CategoryModel>(value: CategoryModel.isEmpty)
    
    
    init(chuckNorrisAPI: ChuckNorrisAPIType,
         coordinator: CoordinatorType,
         cacheFactsRealm: CacheFactsRealmType) {
        self.chuckNorrisAPI = chuckNorrisAPI
        self.coordinator = coordinator
        self.cacheFactsRealm = cacheFactsRealm
        
        setupFactsBinding()
    }
}

//MARK: Setup Bindings
extension FactsViewModel {
    
    // Inputs
    func sharedButton(fact: FactModel) -> CocoaAction {
        return CocoaAction { [weak self] in
            if let url = URL(string: fact.url) {
                self?.coordinator
                    .transition(to: .sharedLink(title: fact.title,
                                                link: url), type: .modal)
            }
            return Observable.empty()
        }
    }
    
    func setupFactsBinding() {
        
        self.featch(category: nil)
        
        let cacheFacts: Observable<CacheFactsModel> = self.cacheFactsRealm.fact(on: Date())
        cacheFacts
            .catchError({ error -> Observable<CacheFactsModel> in
                if let cacheError = error as? CacheFactsRealmError, cacheError == .notFoundCache  {
                    return .just(CacheFactsModel.empty)
                }
                return .just(CacheFactsModel.empty)
            })
            .map {
                $0.items.count > 0
            }
            .subscribe(onNext: { [weak self] hasCache in
                if !hasCache {
                    self?.featch(category: nil)
                }
            }).disposed(by: bag)
        
        let combined =
            Observable
                .combineLatest(factsByFecth.startWith([FactModel.empty]), cacheFacts)
                .map { [weak self] values -> [FactModel] in
                    
                    let fetches: [FactModel] = values.0
                    let caches: CacheFactsModel = values.1
                    
                    if caches.items.count > 0  {
                        return caches.items.toArray()
                    }
                    
                    if fetches.count > 0 {
                        return fetches
                    }
                    
                    self?.featch(category: nil)
                    return []
        }
        
        combined
            .subscribe({ [weak self] fetch in
                self?.facts.onNext(fetch.element ?? [])
        }).disposed(by: bag)
    }
}

//MARK: Functions for Service
extension FactsViewModel {
    func featch(category: CategoryModel?) {
        let observable = chuckNorrisAPI.facts(category: category)
            .retry(3)
            .catchErrorJustReturn(FactResponse.empty)
            .map { factResponse -> [FactModel] in
                let factModels:[FactModel] = factResponse.result.map { response in
                    let factModel = FactModel()
                    factModel.setModel(by: response)
                    return factModel
                }
                return factModels
        }
        
        observable
            .subscribe(onNext: { self.factsByFecth.onNext($0) })
            .disposed(by: bag)
    }
}
