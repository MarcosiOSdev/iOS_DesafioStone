//
//  CategorySearchViewModel.swift
//  DesafioStone
//
//  Created by Marcos Felipe Souza on 23/12/19.
//  Copyright © 2019 Marcos Felipe Souza. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import CoreData

class SearchFactsViewModel: BindingViewModelType {
    
    //MARK: - Inject Properties
    var disposedBag = DisposeBag()
    var coordinator: CoordinatorType
    var lastSearchCoreData: LastSearchCoreDataType
    
    var input: SearchFactsViewModel.UIInput
    var output: SearchFactsViewModel.UIOutput
    
    var completion: AnyObserver<CategoryModel>?
    private let suggestionList = ["GAMES", "SPORT", "DEV", "SCIENCE", "TECHNOLOGY", "MUSIC", "TRAVEL", "CARRER"]
    
    struct UIInput {
        var searchText: AnyObserver<String>
    }
    
    struct UIOutput {
        var lastSearch: Signal<[String]>
        var suggestionSearch: Driver<[String]>
        var title: Driver<String>
        var suggestionTitle: Driver<String>
        var placeholderSearch: Driver<String>
    }
    
    //MARK: Inputs property
    private let searchTextObservable: PublishSubject<String> = .init()
    
    //MARK: Output property
    private let lastSearch = BehaviorRelay<[String]>(value: [])
    
    private static var searched = [String]()
    
    init(coordinator: CoordinatorType,
         lastSearchCoreData: LastSearchCoreDataType) {
        
        self.coordinator = coordinator
        self.lastSearchCoreData = lastSearchCoreData
        
        let suggestionSearch = Driver<[String]>.of(suggestionList)
        
        let title =
            Observable<String>
                .of(StringText.sharing.text(by: .titleSearchFacts))
                .asDriver(onErrorJustReturn: "")
        
        let suggestionTitle =
            Observable<String>
                .of(StringText.sharing.text(by: .suggestionTitleSearchScene))
                .asDriver(onErrorJustReturn: "")
        
        let placeholderSearch =
            Driver<String>
                .of(StringText.sharing.text(by: .searchPlaceholderSearchScene))
                .asDriver(onErrorJustReturn: "")
        
        output = UIOutput(lastSearch: lastSearch.asSignal(onErrorJustReturn: []),
                          suggestionSearch: suggestionSearch,
                          title: title,
                          suggestionTitle: suggestionTitle,
                          placeholderSearch: placeholderSearch)
        
        input = UIInput(searchText: searchTextObservable.asObserver())
        
        self.binding()
        self.loadingLastSearch()
    }
    
    private func binding() {
        self.searchTextObservable.asObservable()
            .observeOn(MainScheduler.instance)
            .map { $0 }
            .subscribe({ event in
                guard let element = event.element else { return }
                
                var category: CategoryModel? = nil
                if !self.suggestionList.contains(element) {
                    category = self.saveLastSearch(element)
                
                } else {
                    let categoryString = self.suggestionList.filter{$0 == element}.first
                    if categoryString != nil {
                        category = CategoryModel(uid: 0, value: categoryString!)
                    }
                }
                self.infoSearchToBackScene(category!)
                
            }).disposed(by: disposedBag)
    }
}

//MARK: - CoreData Functions -
extension SearchFactsViewModel {
    private func saveLastSearch(_ element: String) -> CategoryModel {
        let categoryModel = CategoryModel(uid: UUID().hashValue, value: element)
        let exist = self.lastSearchCoreData.containCategory(element)
        if !exist {
            self.lastSearchCoreData.save(category: categoryModel)
        } else {
            self.lastSearchCoreData.update(category: categoryModel)
        }        
        return categoryModel
    }
    
    private func loadingLastSearch() {
        self.lastSearchCoreData.fetch()
            .subscribe(onNext: { [weak self] categories in
                let lastSearches = categories.map {$0.value}
                self?.lastSearch.accept(lastSearches)
        }).disposed(by: self.disposedBag)
    }
}

//MARK: - Coordinators Functions -
extension SearchFactsViewModel {
    private func infoSearchToBackScene(_ element: CategoryModel) {
        self.completion?.onNext(element)
        self.coordinator.pop()
    }
}
