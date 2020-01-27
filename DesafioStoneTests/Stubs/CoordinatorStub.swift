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
    var scenes: [Scene] = []
    
    init(currentScene: Scene) {
        
        switch currentScene {
        case .facts:
            scenes = [.facts]
        case .searchCategory(let completion):
            scenes = [.facts, .searchCategory(completion: completion)]
        default:
            scenes = []
        }
    }
    
    func transition(to scene: Scene, type: SceneTransitionType) -> Completable {
        currentSceneObservable.onNext(scene.rawValue)
        scenes.append(scene)
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
        return scenes.last!
    }
    
    func pop(animated: Bool) -> Completable {
        
        let finish = PublishSubject<Void>()
        finish.onCompleted()
        
        if !scenes.isEmpty {
            self.scenes.removeLast()
        }
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
