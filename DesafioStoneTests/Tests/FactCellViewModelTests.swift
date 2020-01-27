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
@testable import DesafioStone

class FactCellViewModelTests: XCTestCase {

    var viewModel: FactsViewModel!
    var scheduler: TestScheduler!
    var coordinatorStub: CoordinatorStub!
    
    let disposedBag = DisposeBag()
    
    
    override func setUp() {
        self.coordinatorStub = CoordinatorStub(currentScene: .facts)
        self.viewModel = FactsViewModel(chuckNorrisAPI: ChuckNorrisAPIStub(), coordinator: self.coordinatorStub)
        self.scheduler = TestScheduler(initialClock: 0)
    }
    
    override func tearDown() {
        self.viewModel = nil
        self.scheduler = nil
    }
    
    func test_init_viewModel_with_3_facts() {
        XCTAssertEqual(try  viewModel.output.facts.toBlocking(timeout: 1.0).first()?.count, 3)
    }
    
    func test_init_viewModel_normal() {
        XCTAssertEqual(try viewModel.output.facts.toBlocking(timeout: 1.0).first()?.first!, .normal(factModel: FactModel()))
    }
    
    func test_title_start_at_string() {
        let title = StringText.sharing.text(by: .titleFactScene)
        XCTAssertEqual(try viewModel.output.title.toBlocking(timeout: 1.0).first()!, title)
    }
    
    func test_shared_load_start_at_false() {
        XCTAssertFalse(try viewModel.output.finishedShareFact.toBlocking(timeout: 1.0).first()!)
    }
    
    func test_start_with_empty_result() {
        self.viewModel = FactsViewModel(chuckNorrisAPI: ChuckNorrisAPIEmptyStub(), coordinator: CoordinatorStub(currentScene: .facts))
        do {
            let result: FactsTableViewCellType = try viewModel.output.facts.toBlocking(timeout: 1.0).first()!.first!
            XCTAssertEqual(result, FactsTableViewCellType.empty(viewData: EmptyFactViewData(infoMessage: "", descriptionImage: "")))
        } catch {
            XCTFail("Erro in test_with_empty_result with: \(error.localizedDescription)")
        }
    }
    
    func test_start_with_error_network() {
        self.viewModel = FactsViewModel(chuckNorrisAPI: ChuckNorrisAPIErrorNetworkStub(), coordinator: CoordinatorStub(currentScene: .facts))
        let result = try! viewModel.output.facts.toBlocking(timeout: 1.0).first()!.first!
        if case let FactsTableViewCellType.error(message) = result {
            let genericError = StringText.sharing.text(by: .defaultError)
            XCTAssertEqual(genericError, message)
        
        } else {
            XCTFail("ERROR")
        }
    }
    
    func test_without_category_set_uncategorized(){
        do {
            let result: FactsTableViewCellType = try (viewModel.output.facts.toBlocking(timeout: 1.0).first()?.first!)!
            
            if case let FactsTableViewCellType.normal(factModel) = result {
                let uncategorized = StringText.sharing.text(by: .tagUncategorized)
                XCTAssertEqual(factModel.tag, uncategorized)
            } else {
                XCTFail("Sem model")
            }
        } catch {
            XCTFail("Erro in test_without_category_set_uncategorized with: \(error.localizedDescription)")
        }
    }
    
    func test_loading_when_sharing_any_fact() {
        let sharingFakeTap = scheduler.createObserver(Bool.self)
        
        viewModel.output
            .finishedShareFact
            .drive(sharingFakeTap)
            .disposed(by: disposedBag)
                
        scheduler.createColdObservable([
            .next(10, FactModel.empty)
            ])
            .bind(to: viewModel.input.sharedFact)
            .disposed(by: disposedBag)
        
        scheduler.createColdObservable(
            [.next(15, ())
            ])
            .bind(to: coordinatorStub.completionOk)
            .disposed(by: disposedBag)
        
        scheduler.start()
        XCTAssertEqual(sharingFakeTap.events, [ .next(0, false), //Nothing shared
                                                .next(10, true), // Sharing
                                                .next(15, false)]) //Share was finished
    }
    
    func test_tap_search() {
        
        let nextScene = scheduler.createObserver(Int.self)
        
        coordinatorStub
            .currentSceneObservable
            .asDriver(onErrorJustReturn: 0)
            .drive(nextScene)
            .disposed(by: disposedBag)
        
        scheduler.createColdObservable([
            .next(10, ())
            ])
            .bind(to: viewModel.input.searchViewButtonTapped)
            .disposed(by: disposedBag)
        
        scheduler.start()
        XCTAssertEqual(nextScene.events, [.next(10, 3)]) //SearchCategory tem rawValue 3
    }
    
//    func test_reload_with_empty() {
//        let factsReloadFake = scheduler.createObserver([FactsTableViewCellType].self)
//        viewModel.output
//            .facts
//            .asDriver(onErrorJustReturn: [.empty(viewData: EmptyFactViewData())])
//            .drive(factsReloadFake)
//            .disposed(by: disposedBag)
//        
//        scheduler.createColdObservable([
//            .next(10, ())
//        ]).bind(to: self.viewModel.input.reloadEvent)
//          .disposed(by: disposedBag)
//        
//        scheduler.start()
//        
//        factsReloadFake.events.forEach { record in
//            record.value.element?.forEach({ (cellType) in
//                print(cellType)
//            })
//        }
//        
//        XCTAssertEqual(factsReloadFake.events, [
//            .next(0, FactsTableViewCellType.mockFactsResult),
//            .next(10, FactsTableViewCellType.mockLoadResult),
//            .next(10, FactsTableViewCellType.mockFactsResult),
//        ])
//    }
    
}

