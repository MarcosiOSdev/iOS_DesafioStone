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
    case normal(factModel: FactModel)
    case error(message: String)
    case empty
}

//MARK: List of Variables
class FactsViewModel: BindingViewModelType {
    
    var input: FactsViewModel.UIInput
    let output: FactsViewModel.UIOutput
    
    struct UIInput {
        var searchViewButtonTapped: AnyObserver<Void>
        var sharedFact: AnyObserver<FactModel>
        var reloadEvent: AnyObserver<Void>
    }

    struct UIOutput {
        var facts: Signal<[FactsTableViewCellType]>
        var title: Driver<String>
        var finishedShareFact: Driver<Bool>
    }
    
    private let chuckNorrisAPI: ChuckNorrisAPIType
    private let coordinator: CoordinatorType
    var disposedBag = DisposeBag()
    
    private var facts = BehaviorRelay<[FactsTableViewCellType]> (value: [])
    private var _isLoadingShare = BehaviorSubject<Bool>(value: false)
    private var searchViewButtonTapped: PublishSubject<Void> = .init()
    private var reloadEvent: PublishSubject<Void> = .init()
    private var sharedFact: PublishSubject<FactModel> = PublishSubject<FactModel>()
    
    
    init(chuckNorrisAPI: ChuckNorrisAPIType,
         coordinator: CoordinatorType) {
        self.chuckNorrisAPI = chuckNorrisAPI
        self.coordinator = coordinator
                        
        
        input = UIInput(searchViewButtonTapped: searchViewButtonTapped.asObserver(),
                        sharedFact: sharedFact.asObserver(),
                        reloadEvent: reloadEvent.asObserver())
        
        let title = Observable<String>
            .of(StringText.sharing.text(by: .titleFactScene))
            .asDriver(onErrorJustReturn: "")
        
        output = UIOutput(facts: facts.asSignal(onErrorJustReturn: [.empty]),
                          title: title,
                          finishedShareFact: self._isLoadingShare.asDriver(onErrorJustReturn: false))
        
        self.searchViewButtonTapped.subscribe(onNext: { _ in
            print("Clicou")
        }).disposed(by: disposedBag)
        
        reloadEvent.skip(1)
            .asObservable()
            .subscribe(onNext: { _ in
                self.featch(category: nil)
            }).disposed(by: disposedBag)
        
        sharedFact
            .skip(1)
            .map { $0 }
            .subscribe({ event in
                self._isLoadingShare.onNext(true)
                if let model = event.element {
                    self.openSharedActionSheet(model)
                }
            })
            .disposed(by: disposedBag)

        
        self.featch(category: nil)
    }
    
    private func openSharedActionSheet(_ fact: FactModel) {
        if let url = URL(string: fact.url) {
            coordinator
                .transition(to: .sharedLink(title: fact.title,
                                        link: url,
                                        completion: CocoaAction {
                                            self._isLoadingShare.onNext(false)
                                            return Observable.empty()
            }), type: .modal)
        }
    }
}

//MARK: Functions for Service
extension FactsViewModel {
    private func featch(category: CategoryModel?) {
        
        let observable = chuckNorrisAPI.facts(category: category)
            .retry(3)
        
        observable.subscribe(onNext: { factResponse in
            guard factResponse.result.count > 0 else {
                self.facts.accept([.empty])
                return
            }
            
            let factsCell = factResponse.result.map { result -> FactsTableViewCellType in
                let factModel = FactModel()
                factModel.setModel(by: result)
                self.tagUncategorized(in: factModel)
                return FactsTableViewCellType.normal(factModel: factModel)
            }
            self.facts.accept(factsCell)            
        }, onError: { error in
            let genericError = StringText.sharing.text(by: .defaultError)
            self.facts.accept([.error(message: genericError)])
        })
        .disposed(by: disposedBag)
    }
    
    func tagUncategorized(in factModel: FactModel) {
        if factModel.tag.isEmpty {
            factModel.tag = StringText.sharing.text(by: .tagUncategorized)
        }
    }
}
