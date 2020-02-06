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


struct EmptyFactViewData {
    var infoMessage: String = ""
    var descriptionImage: String = ""
}

enum FactsTableViewCellType {
    case normal(factModel: FactModel)
    case error(message: String)
    case empty(viewData: EmptyFactViewData)
    case loading
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
    //MARK: - Property Inject
    private let chuckNorrisAPI: ChuckNorrisAPIType
    private let coordinator: CoordinatorType
    var disposedBag = DisposeBag()
    
    
    //MARK: - Output Property Private
    private var facts = BehaviorRelay<[FactsTableViewCellType]> (value: [])
    private var _isLoadingShare = BehaviorSubject<Bool>(value: false)
    
    //MARK: - Input Property Private
    private var searchViewButtonTapped: PublishSubject<Void> = .init()
    private var reloadEvent: PublishSubject<Void> = .init()
    private var sharedFact: PublishSubject<FactModel> = PublishSubject<FactModel>()
    
    //MARK: - Input Property like Completion
    private var searchCategory: PublishSubject<CategoryModel> = .init()
    private var sharedFactsActionSheet: PublishSubject<Void> = .init()
    
    //MARK: - Save Property
    private var lastSearchCategory: CategoryModel?
    
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
        
        output = UIOutput(facts: facts.asSignal(onErrorJustReturn: [.empty(viewData: EmptyFactViewData())]),
                          title: title,
                          finishedShareFact: self._isLoadingShare.asDriver(onErrorJustReturn: false))
        
        self.searchViewButtonTapped.subscribe(onNext: { _ in
            self.openSearch()
        }).disposed(by: disposedBag)
        
        reloadEvent
            .asObservable()
            .subscribe(onNext: { _ in
                let category = self.lastSearchCategory
                self.featch(category: category)
            }).disposed(by: disposedBag)
        
        sharedFact           
            .map { $0 }
            .subscribe({ event in
                self._isLoadingShare.onNext(true)
                if let model = event.element {
                    self.openSharedActionSheet(model)
                }
            })
            .disposed(by: disposedBag)

        searchCategory.subscribe(onNext: { category in
            self.lastSearchCategory = category
            self.featch(category: category)
        }).disposed(by: self.disposedBag)
        
        self.sharedFactsActionSheet.subscribe(onNext: { _ in
            self._isLoadingShare.onNext(false)
        }).disposed(by: self.disposedBag)
        
        self.featch(category: nil)
        
        self.facts.asObservable().subscribe(onNext: { facts in
            let factsMessageWatchOS = FactsMessageWatchOS(facts: [FactModel.empty])
            WatchOSConnectivity.sharing.sendMessage(message: factsMessageWatchOS)            
        }).disposed(by: self.disposedBag)
    }
}

//MARK: - Aux Functions -
extension FactsViewModel {
    
    private func buildEmptyCell(with category: String) -> EmptyFactViewData {
        let descriptionImage = StringText.sharing.text(by: .tapToReturnEmptyCellFact)
        var infoMessage = StringText.sharing.text(by: .valueIsEmptyEmptyCellFact)
        infoMessage = String(format: infoMessage, category)
        
        return EmptyFactViewData(infoMessage: infoMessage,
                                 descriptionImage: descriptionImage)
    }
    
    private func openSharedActionSheet(_ fact: FactModel) {
        if let url = URL(string: fact.url) {
            self.coordinator
                    .transition(to: .sharedLink(title: fact.title,
                                                link: url,
                                                completion: sharedFactsActionSheet.asObserver()),
                                                type: .modal)
        }
    }
    
    private func openSearch() {
        coordinator.transition(to: .searchCategory(completion: searchCategory.asObserver()),
                               type: .push)
    }
}


//MARK: - Functions for Service -
extension FactsViewModel {
    private func featch(category: CategoryModel?) {
        self.facts.accept([.loading, .loading, .loading])
        let observable = chuckNorrisAPI.facts(category: category)
            .retry(3)

        observable.subscribe(onNext: { factResponse in
            guard factResponse.result.count > 0 else {
                let viewData = self.buildEmptyCell(with: category?.value ?? "")
                self.facts.accept([.empty(viewData: viewData)])
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
