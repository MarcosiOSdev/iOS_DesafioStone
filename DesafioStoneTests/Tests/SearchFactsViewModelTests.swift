//
//  SearchCategoryViewModelTests.swift
//  DesafioStoneTests
//
//  Created by Marcos Felipe Souza on 23/12/19.
//  Copyright © 2019 Marcos Felipe Souza. All rights reserved.
//

import Foundation
import XCTest
import RxSwift
import RxCocoa
import RxTest
import RxBlocking

@testable import DesafioStone

class SearchFactsViewModelTests: XCTestCase {
    
    var viewModel: SearchFactsViewModel!
    var scheduler: TestScheduler!
    var disposedBag = DisposeBag()
    
    override func setUp() {
        
        viewModel = SearchFactsViewModel(coordinator: CoordinatorStub(),
                                         lastSearchCoreData: LastSearchCoreData())
        scheduler = TestScheduler(initialClock: 0)
    }
    
    override func tearDown() {
        viewModel = nil
    }
    
    func test_start_suggestion_values() {
        let suggestionList = ["GAMES", "SPORT", "DEV", "SCIENCE", "TECHNOLOGY", "MUSIC", "TRAVEL", "CARRER"]
        XCTAssertEqual(try viewModel.output.suggestionSearch.toBlocking(timeout: 1.0).first(), suggestionList)
    }
    
    func test_start_title_value() {
        let title = StringText.sharing.text(by: .titleSearchFacts)
        XCTAssertEqual(try viewModel.output.title.toBlocking(timeout: 1.0).first(), title)
    }
    
    func test_tap_suggestion_value() {
        let suggestionValueFake = scheduler.createObserver([String].self)
        viewModel.output
            .lastSearch
            .asObservable()
            .bind(to: suggestionValueFake)
            .disposed(by: disposedBag)
        
        scheduler.createColdObservable([
            .next(10, "GAMES"),
            .next(20, "SPORT")
            ])
            .bind(to: viewModel.input.searchText)
            .disposed(by: disposedBag)
        
        scheduler.start()
        
        XCTAssertEqual(suggestionValueFake.events, [
            .next(0, []),
            .next(10, ["GAMES"]),
            .next(20, ["GAMES", "SPORT"])
            ])
    }
    
}
