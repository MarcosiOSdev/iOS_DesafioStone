//
//  FactViewModel.swift
//  DesafioStone
//
//  Created by Marcos Felipe Souza on 24/07/19.
//  Copyright © 2019 Marcos Felipe Souza. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import Action

//typealias FactSection = AnimatableSectionModel<String, FactModel>

//MARK: List of Variables
class FactsViewModel {
    private let chuckNorrisAPI: ChuckNorrisAPIType
    private let coordinator: CoordinatorType
    
    var bag = DisposeBag()
    
    //MARK: Outputs
    var facts = BehaviorSubject<[FactModel]> (value: [])
    
    var title: Observable<String> {
        return Observable<String>.of(StringText.sharing.text(by: .titleFactScene))
    }
    let showLoading = BehaviorRelay<Bool>(value: false)

    
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
         coordinator: CoordinatorType) {
        self.chuckNorrisAPI = chuckNorrisAPI
        self.coordinator = coordinator
        setupFactsBinding()
    }
}

//MARK: Setup Bindings
extension FactsViewModel {
    
    // Inputs
    func sharedButton(fact: FactModel) -> CocoaAction {
        self.showLoading.accept(true)
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
    }
}

//MARK: Functions for Service
extension FactsViewModel {
    private func featch(category: CategoryModel?) {
        let observable = chuckNorrisAPI.facts(category: category)
            .retry(3)
            .catchErrorJustReturn(FactResponse.empty)
            .map { factResponse -> [FactModel] in
                let factModels:[FactModel] = factResponse.result.map { [weak self] response in
                    let factModel = FactModel()
                    factModel.setModel(by: response)
                    self?.tagUncategorized(in: factModel)
                    return factModel
                }
                return factModels
        }
        
        observable
            .subscribe(onNext: { self.facts.onNext($0) })
            .disposed(by: bag)
    }
    
    func tagUncategorized(in factModel: FactModel) {
        if factModel.tag.isEmpty {
            factModel.tag = "UNCATEGORIZED"
        }
    }
}
