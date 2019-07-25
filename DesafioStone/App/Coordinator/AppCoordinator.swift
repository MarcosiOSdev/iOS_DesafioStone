//
//  AppCoordinator.swift
//  DesafioStone
//
//  Created by Marcos Felipe Souza on 24/07/19.
//  Copyright © 2019 Marcos Felipe Souza. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AppCoordinator: CoordinatorType {
    
    fileprivate var window: UIWindow?
    fileprivate var currentViewController: UIViewController!
    fileprivate var navigation: UINavigationController!
    
    init(window: UIWindow) {
        self.window = window
    }
    
    static func actualViewController(for viewController: UIViewController) -> UIViewController {
        if let navigationController = viewController as? UINavigationController {
            return navigationController.viewControllers.first!
        } else {
            return viewController
        }
    }
    
    private func startRoot(viewController: UIViewController) -> UIViewController {
        
        let nav = UINavigationController(rootViewController: viewController)
        window!.rootViewController = nav
        window!.makeKeyAndVisible()
        return nav
    }
    
    @discardableResult
    func transition(to scene: Scene, type: SceneTransitionType) -> Completable {
        let subject = PublishSubject<Void>()
        let viewController = scene.dependencyInjection()
        
        switch type {
        case .root:
            self.navigation = startRoot(viewController: viewController) as? UINavigationController
            currentViewController = AppCoordinator.actualViewController(for: viewController)
            subject.onCompleted()
            
        case .push:
            guard let navigationController = currentViewController.navigationController else {
                fatalError("Can't push a view controller without a current navigation controller")
            }
            // one-off subscription to be notified when push complete
            _ = navigationController.rx.delegate          .sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
                .map { _ in }
                .bind(to: subject)
            navigationController.pushViewController(viewController, animated: true)
            currentViewController = AppCoordinator.actualViewController(for: viewController)
            
        case .modal:
            if let nav = viewController.navigationController {
                nav.modalPresentationStyle = .overCurrentContext
                currentViewController.present(nav, animated: true) {
                    subject.onCompleted()
                }
                currentViewController = AppCoordinator.actualViewController(for: nav)
            }
        }
        
        return subject.asObservable()
            .take(1)
            .ignoreElements()
    }
    
    func pop(animated: Bool) -> Completable {
        let subject = PublishSubject<Void>()
        
        if let presenter = currentViewController.presentingViewController {
            currentViewController.dismiss(animated: animated) {
                self.currentViewController = AppCoordinator.actualViewController(for: presenter)
                subject.onCompleted()
            }
        
        } else if let navigationController = currentViewController.navigationController {
            _ = navigationController.rx.delegate                .sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
                .map { _ in }
                .bind(to: subject)
            
            guard navigationController.popViewController(animated: animated) != nil else {
                fatalError("can't navigate back from \(currentViewController)")
            }
            currentViewController = AppCoordinator.actualViewController(for: navigationController.viewControllers.last!)
        } else {
            fatalError("Not a modal, no navigation controller: can't navigate back from \(currentViewController)")
        }
        return subject.asObservable()
            .take(1)
            .ignoreElements()
    }
}
