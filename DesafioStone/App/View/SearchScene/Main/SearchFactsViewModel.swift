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
    var input: SearchFactsViewModel.UIInput
    var output: SearchFactsViewModel.UIOutput
    
    private let suggestionList = ["GAMES", "SPORT", "DEV", "SCIENCE", "TECHNOLOGY", "MUSIC", "TRAVEL", "CARRER"]
    
    struct UIInput {
        var searchText: PublishRelay<String>
    }
    
    struct UIOutput {
        var lastSearch: Driver<[String]>
        var suggestionSearch: Driver<[String]>
        var title: Driver<String>
        var suggestionTitle: Driver<String>
        var placeholderSearch: Driver<String>
    }
    
    
    private let searchTextObservable: PublishRelay<String> = .init()
    private let lastSearch: BehaviorSubject = BehaviorSubject<[String]>(value: [])
    
    private var searched: Set<String> = [] {
        didSet {
            let list = self.searched.map{$0}
            self.lastSearch.onNext(list)
        }
    }
    
    init() {
        
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
        
        output = UIOutput(lastSearch: lastSearch.asDriver(onErrorJustReturn: []),
                          suggestionSearch: suggestionSearch,
                          title: title,
                          suggestionTitle: suggestionTitle,
                          placeholderSearch: placeholderSearch)
        
        input = UIInput(searchText: searchTextObservable)
        
        self.binding()
    }
    
    func binding() {
        self.searchTextObservable.asObservable()
            .map { $0 }
            .subscribe({ event in
                if let element = event.element {
                    self.searched.insert(element)
                    print(element)
                }
            }).disposed(by: disposedBag)
    }
}
