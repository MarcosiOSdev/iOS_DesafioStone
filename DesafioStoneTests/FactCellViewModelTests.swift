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
import Action
@testable import DesafioStone

class FactCellViewModelTests: XCTestCase {

    var viewModel: FactCellViewModel!
    var scheduler: ConcurrentDispatchQueueScheduler!
    
    override func setUp() {
        self.viewModel = FactCellViewModel(model: FactModel.mockable, sharedAction: self.actionMock())
        self.scheduler = ConcurrentDispatchQueueScheduler(qos: .default)
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
    func test_check_init_title_async() {
        
        let expected = expectation(description: #function)
        var result: String!
        
        self.viewModel.title
            .asObservable()
            .subscribe(onNext: {
                result = $0
                expected.fulfill()
        }).disposed(by: DisposeBag())
        
                
        waitForExpectations(timeout: 1.0) { error in
            guard error == nil else {
                XCTFail(error!.localizedDescription)
                return
            }
            XCTAssertEqual(result, FactModel.mockable.title)
        }
        
    }
}
