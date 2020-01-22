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


class SearchFactsViewModel: BindingViewModelType {
    
    var disposedBag = DisposeBag()
    var coordinator: CoordinatorType
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
    
    
    private let searchTextObservable: PublishSubject<String> = .init()
    private let lastSearch = BehaviorRelay<[String]>(value: [])
    
    private static var searched = [String]()
    
    init(coordinator: CoordinatorType) {
        self.coordinator = coordinator
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
        
        
        /// Search order
        let totalIndices = SearchFactsViewModel.searched.count - 1
        guard totalIndices >= 0 else { return }
        
        var reversedCategory = [String]()

        for arrayIndex in 0...totalIndices {
            reversedCategory.append(SearchFactsViewModel.searched[totalIndices - arrayIndex])
        }
        let returnArray =  Array(reversedCategory.prefix(5))
        self.lastSearch.accept(returnArray)
    }
    
    func binding() {
        self.searchTextObservable.asObservable()
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
                self.infoSearchToBackScene(category! )
                
            }).disposed(by: disposedBag)
    }
    
    private func infoSearchToBackScene(_ element: CategoryModel) {
        self.completion?.onNext(element)
        self.coordinator.pop()
    }
    
    private func saveLastSearch(_ element: String) -> CategoryModel {
        //TODO .. Salvar em CoreData
        SearchFactsViewModel.searched.append(element)
        let list = SearchFactsViewModel.searched.map{$0}
        self.lastSearch.accept(list)
        return CategoryModel(uid: 10, value: element)
    }
}
