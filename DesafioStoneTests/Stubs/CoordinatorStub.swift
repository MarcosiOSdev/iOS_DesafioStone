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

class CoordinatorStub: AppCoordinator {
    
    var completionOk =  BehaviorRelay<Scene>(value: .none)
    
    init() {
        super.init(window: UIApplication.shared.windows.first!)
    }
        
    override func transition(to scene: Scene, type: SceneTransitionType) -> Completable {
        completionOk.accept(scene)
        let finish = PublishSubject<Void>()
        finish.onCompleted()
        return finish.asObservable()
        .take(1)
        .ignoreElements()
    }
    
    
}
