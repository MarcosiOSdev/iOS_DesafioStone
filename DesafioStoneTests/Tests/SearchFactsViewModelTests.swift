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
    var coordinatorStub: CoordinatorStub!
    
    
    override func setUp() {
        coordinatorStub = CoordinatorStub(currentScene: .searchCategory(completion: nil))        
        viewModel = SearchFactsViewModel(coordinator: coordinatorStub,
                                         lastSearchCoreData: LastSearchCoreData())
        scheduler = TestScheduler(initialClock: 0)
    }
    
    override func tearDown() {
        coordinatorStub = nil
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
        let completionFake = PublishSubject<CategoryModel>()
        
        viewModel.output
            .lastSearch
            .asObservable()
            .bind(to: suggestionValueFake)
            .disposed(by: disposedBag)
        
        scheduler.createColdObservable([
            .next(10, "GAMES")
            ])
            .bind(to: viewModel.input.searchText)
            .disposed(by: disposedBag)
                
        viewModel.completion = completionFake.asObserver()
        
        let expect = expectation(description: #function)
        var selected = ""
        completionFake.asObservable().subscribe(onNext: { element in
            expect.fulfill()
            selected = element.value
        }).disposed(by: self.disposedBag)
                        
        scheduler.start()
        
        //Não armazena valor no lastSearch
        XCTAssertEqual(suggestionValueFake.events, [ .next(0, []) ])
        
        waitForExpectations(timeout: 3.0) { error in
            if error != nil {
                XCTFail()
            }
            XCTAssertEqual("GAMES", selected)
        }
    }
    
}
