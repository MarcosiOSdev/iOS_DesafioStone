//
//  DesafioStoneTests.swift
//  DesafioStoneTests
//
//  Created by Marcos Felipe Souza on 24/07/19.
//  Copyright © 2019 Marcos Felipe Souza. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest
import RxBlocking
import Action
@testable import DesafioStone

class FactCellViewModelTests: XCTestCase {

    var viewModel: FactsViewModel!
    var scheduler: ConcurrentDispatchQueueScheduler!
    let bag = DisposeBag()
    
    var testScheduler: TestScheduler!
    
    override func setUp() {
        self.viewModel = FactsViewModel(chuckNorrisAPI: ChuckNorrisAPIStub(), coordinator: CoordinatorStub())
        self.scheduler = ConcurrentDispatchQueueScheduler(qos: .default)
        self.testScheduler = TestScheduler(initialClock: 0)
    }
    
    override func tearDown() {
        self.viewModel = nil
        self.scheduler = nil
    }

    func actionMock() -> CocoaAction {
        return CocoaAction {
            return Observable.empty()
        }
    }
    
    func test_init_viewModel() {
        let factsCellObservable = viewModel.output.facts.asObservable().subscribeOn(self.scheduler)
        XCTAssertEqual(try factsCellObservable.toBlocking(timeout: 1.0).first()?.count, 3)
    }
    
    func test_init_viewModel_normal() {
        let factsCellObservable = viewModel.output.facts.asObservable().subscribeOn(self.scheduler)
        XCTAssertEqual(try factsCellObservable.toBlocking(timeout: 1.0).first()?.first!, .normal(factModel: FactModel()))
    }
    
    func test_without_category_set_uncategorized(){
        let factCellObservable = viewModel.output.facts.asObservable().subscribeOn(self.scheduler)
        
        do {
            let result: FactsTableViewCellType = try (factCellObservable.toBlocking(timeout: 1.0).first()?.first!)!
            
            if case let FactsTableViewCellType.normal(factModel) = result {
                let uncategorized = StringText.sharing.text(by: .tagUncategorized)
                XCTAssertEqual(factModel.tag, "Uncategorized")
                XCTAssertEqual(factModel.tag, uncategorized)
            } else {
                XCTFail("Sem model")
            }
        } catch {
            XCTFail("Erro in test_without_category_set_uncategorized with: \(error.localizedDescription)")
        }
    }
    
    func test_with_empty_result() {
        self.viewModel = FactsViewModel(chuckNorrisAPI: ChuckNorrisAPIEmptyStub(), coordinator: CoordinatorStub())
        
        let factCellObservable = viewModel.output.facts.asObservable().subscribeOn(self.scheduler)
        do {
            let result: FactsTableViewCellType = try factCellObservable.toBlocking(timeout: 1.0).first()!.first!
            XCTAssertEqual(result, FactsTableViewCellType.empty)
        } catch {
            XCTFail("Erro in test_with_empty_result with: \(error.localizedDescription)")
        }
    }
    
    
}
