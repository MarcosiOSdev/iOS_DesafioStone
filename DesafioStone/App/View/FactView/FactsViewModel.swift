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
enum FactsTableViewCellType {
    case normal(cellViewModel: FactCellViewModel)
    case error(message: String)
    case empty
}

//MARK: List of Variables
class FactsViewModel {
    private let chuckNorrisAPI: ChuckNorrisAPIType
    private let coordinator: CoordinatorType
    
    var bag = DisposeBag()
    
    private var loadInProgress = BehaviorRelay(value: true)
    private var facts = BehaviorRelay<[FactsTableViewCellType]> (value: [])
    
    init(chuckNorrisAPI: ChuckNorrisAPIType,
         coordinator: CoordinatorType) {
        self.chuckNorrisAPI = chuckNorrisAPI
        self.coordinator = coordinator
        setupFactsBinding()
    }
    
    func setupFactsBinding() {
        self.featch(category: nil)
    }
    
    lazy var searchViewButtonTapped: Action<Void, Void> = { this in
        return Action { [weak self] element in
            print("Vai pesquisar ... tem que fazer")
            //            self?.coordinator.transition(to: .searchView, type: .push)
            
            this.facts.accept([])
            
            return Observable.empty()
        }
    }(self)
    var categoryForSearch = BehaviorSubject<CategoryModel>(value: CategoryModel.isEmpty)
}

//MARK: Inputs
extension FactsViewModel {
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
    
    
}

//MARK: Output
extension FactsViewModel {
    var factsCell: Observable<[FactsTableViewCellType]> {
        return facts.asObservable()
    }
    
    var onShowLoading: Observable<Bool> {
        return loadInProgress
            .asObservable()
            .distinctUntilChanged()
    }
    var title: Observable<String> {
        return Observable<String>.of(StringText.sharing.text(by: .titleFactScene))
    }
}

//MARK: Functions for Service
extension FactsViewModel {
    private func featch(category: CategoryModel?) {
        let observable = chuckNorrisAPI.facts(category: category)
            .retry(3)
        
        observable.subscribe(onNext: { [weak self] factResponse in
            self?.loadInProgress.accept(false)
            
            guard let strongSelf = self else { return }
            
            guard factResponse.result.count > 0 else {
                strongSelf.facts.accept([.empty])
                return
            }
            
            let factsCell = factResponse.result.map { result -> FactsTableViewCellType in
                let factModel = FactModel()
                factModel.setModel(by: result)
                strongSelf.tagUncategorized(in: factModel)
                let cellViewModel = FactCellViewModel(model: factModel, sharedAction: strongSelf.sharedButton(fact: factModel))
                return FactsTableViewCellType.normal(cellViewModel: cellViewModel)
            }
            self?.facts.accept(factsCell)
            
        }, onError: { [weak self] error in
            self?.loadInProgress.accept(false)
            self?.facts.accept([.error(message: "Ocorreu um erro")])
        })
        .disposed(by: bag)
    }
    
    func tagUncategorized(in factModel: FactModel) {
        if factModel.tag.isEmpty {
            factModel.tag = "UNCATEGORIZED"
        }
    }
}
