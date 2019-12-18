//
//  CoordinatorType.swift
//  DesafioStone
//
//  Created by Marcos Felipe Souza on 24/07/19.
//  Copyright © 2019 Marcos Felipe Souza. All rights reserved.
//

import UIKit
import RxSwift


/// Protocolo que tem assinaturas de todo os coordinators
protocol CoordinatorType: AnyObject {
    
    /// Adicionar uma scene para uma outra
    @discardableResult
    func transition(to scene: Scene, type: SceneTransitionType) -> Completable
    
    /// Pop para tirar a tela do stack da navigationController ou dismiss uma modal.
    @discardableResult
    func pop(animated: Bool) -> Completable
    
    ///Pegar a atual navigationController
    func currentNavigationController() -> UINavigationController
    
    ///Pegar a atual viewController
    func currentView() -> UIViewController
    
    ///Pegar a atual Scene
    func currentScene() -> Scene
}

extension CoordinatorType {
    @discardableResult
    func pop() -> Completable {
        return pop(animated: true)
    }
}
