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
    
    func test_check_init_viewModel() {
        let factsCellObservable = viewModel.output.facts.asObservable().subscribeOn(self.scheduler)
        XCTAssertEqual(try factsCellObservable.toBlocking(timeout: 1.0).first()?.count, 3)
    }
    
    func test_check_init_viewModel_normal() {
        let factsCellObservable = viewModel.output.facts.asObservable().subscribeOn(self.scheduler)
        XCTAssertEqual(try factsCellObservable.toBlocking(timeout: 1.0).first()?.first!, .normal(factModel: FactModel()))
    }
    
    
//    func test_check_tag() {
//        let tagObservable = self.viewModel.tag.asObservable().subscribeOn(self.scheduler)
//        XCTAssertEqual(try tagObservable.toBlocking(timeout: 1.0).first(), FactModel.mockable.tag)
//    }
    
//    func test_check_font_normal() {
//        let modelMock = FactModel.mockable
//        modelMock.title = "Teste para palavras com font normal devem ter acima de 80 caracteres. Devemos fazer o imblometion."
//        self.viewModel = FactCellViewModel(model: modelMock, sharedAction: self.actionMock())
//        let idObservable = self.viewModel.font.asObservable().subscribeOn(self.scheduler)
//        XCTAssertEqual(try idObservable.toBlocking(timeout: 1.0).first(), .normal)
//    }
//
//    func test_tap_shared() {
//        let isLoading = testScheduler.createObserver(Bool.self)
//        self.viewModel
//            .loadInProgress
//            .drive(isLoading)
//            .disposed(by: self.bag)
//
//
//        testScheduler.createColdObservable([.next(10, ())])
//            .bind(to: self.viewModel.onTappedButton)
//            .disposed(by: bag)
//
//        testScheduler.start()
//
//        XCTAssertEqual(isLoading.events, [
//            .next(0, false),
//            .next(10, true)
//        ])
//    }
}
