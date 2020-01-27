//
//  CoordinatorStub.swift
//  DesafioStoneTests
//
//  Created by Marcos Felipe Souza on 29/11/19.
//  Copyright © 2019 Marcos Felipe Souza. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

@testable import DesafioStone

class CoordinatorStub: CoordinatorType {
    
    var completionOk = PublishRelay<Void>()
    var currentSceneObservable = PublishSubject<Int>()
    let disposedBag = DisposeBag()
        
    func transition(to scene: Scene, type: SceneTransitionType) -> Completable {
        currentSceneObservable.onNext(scene.rawValue)
        switch scene {
        case .sharedLink(_, _, let completion):
            completionOk.asObservable()
                .subscribe({ _ in
                completion?.onNext(Void())
            }).disposed(by: disposedBag)
        default:
            break;
        }
        
        
        
        let finish = PublishSubject<Void>()
        finish.onCompleted()
        return finish.asObservable()
        .take(1)
        .ignoreElements()
    }
}

extension CoordinatorStub {
    func currentScene() -> Scene {
        return .none
    }
    
    func pop(animated: Bool) -> Completable {
        let finish = PublishSubject<Void>()
        finish.onCompleted()
        return finish.asObservable()
            .take(1)
            .ignoreElements()
    }
    
    func currentNavigationController() -> UINavigationController {
        return UINavigationController()
    }
    
    func currentView() -> UIViewController {
        return UIViewController()
    }
}
