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
struct FactsViewModel: BindingViewModelType {
    
    let input: FactsViewModel.UIInput
    let output: FactsViewModel.UIOutput
    
    struct UIInput {
        var searchViewButtonTapped: AnyObserver<Void>
        let sharedButton: BehaviorRelay<FactModel>
    }

    struct UIOutput {
        var facts: Driver<[FactsTableViewCellType]>
        var title: Driver<String>
    }
    
    private let chuckNorrisAPI: ChuckNorrisAPIType
    private let coordinator: CoordinatorType
    var disposedBag = DisposeBag()
    
    private var facts = BehaviorRelay<[FactsTableViewCellType]> (value: [])
    private var searchViewButtonTapped: PublishSubject<Void> = .init()
    private var sharedFact: BehaviorRelay<FactModel> = BehaviorRelay<FactModel>(value: FactModel.empty)

    init(chuckNorrisAPI: ChuckNorrisAPIType,
         coordinator: CoordinatorType) {
        self.chuckNorrisAPI = chuckNorrisAPI
        self.coordinator = coordinator
                        
        sharedFact
            .skip(1)
            .filter { $0 != FactModel.empty }
            .subscribe(onNext: { model in
                FactsViewModel.openSharedActionSheet(model, coordiantor: coordinator)
            })
            .disposed(by: disposedBag)
        
        input = UIInput(searchViewButtonTapped: searchViewButtonTapped.asObserver(),
                        sharedButton: sharedFact)
        
        let title = Observable<String>
            .of(StringText.sharing.text(by: .titleFactScene))
            .asDriver(onErrorJustReturn: "")
        
        output = UIOutput(facts: facts.asDriver(onErrorJustReturn: [.empty]), title: title)
        
        self.searchViewButtonTapped.subscribe(onNext: { _ in
            print("Clicou")
        }).disposed(by: disposedBag)
        
        self.featch(category: nil)
    }
    
    static func openSharedActionSheet(_ fact: FactModel, coordiantor: CoordinatorType) {
        if let url = URL(string: fact.url) {
            coordiantor
                .transition(to: .sharedLink(title: fact.title,
                                        link: url,
                                        completion: CocoaAction {
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
            self.facts.accept([.error(message: "Ocorreu um erro")])
        })
        .disposed(by: disposedBag)
    }
    
    func tagUncategorized(in factModel: FactModel) {
        if factModel.tag.isEmpty {
            factModel.tag = "UNCATEGORIZED"
        }
    }
}
