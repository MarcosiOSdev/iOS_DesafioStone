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
    
    fileprivate weak var window: UIWindow?
    fileprivate var currentViewController: UIViewController!
    fileprivate var currentNavigation: UINavigationController!
    fileprivate var listScene: [Scene] = []
    
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
        self.listScene.append(scene)
        
        let subject = PublishSubject<Void>()
        let viewController = scene.dependencyInjection(coordinator: self)
        switch type {
        case .root:
            self.currentNavigation = startRoot(viewController: viewController) as? UINavigationController
            currentViewController = AppCoordinator.actualViewController(for: currentNavigation)
            subject.onCompleted()
            
        case .push:
            guard let navigationController = currentNavigation else {
                fatalError("Can't push a view controller without a current navigation controller")
            }
            // one-off subscription to be notified when push complete
            _ = navigationController.rx.delegate.sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
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
            } else {
                viewController.modalPresentationStyle = .overCurrentContext
                self.currentViewController.present(viewController, animated: true) {
                    subject.onCompleted()
                }
            }
        }
        
        return subject.asObservable()
            .take(1)
            .ignoreElements()
    }
    
    func pop(animated: Bool) -> Completable {
        let subject = PublishSubject<Void>()
        self.listScene.removeLast()
        if let presenter = currentViewController.presentingViewController {
            currentViewController.dismiss(animated: animated) {
                self.currentViewController = AppCoordinator.actualViewController(for: presenter)
                subject.onCompleted()
            }
        
        } else if let navigationController = currentViewController.navigationController {
            _ = navigationController.rx.delegate.sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
                .map { _ in }
                .bind(to: subject)
            
            guard navigationController.popViewController(animated: animated) != nil else {
                let vcString = String(describing: currentViewController)
                fatalError("can't navigate back from \(vcString)")
            }
            currentViewController = AppCoordinator.actualViewController(for: navigationController.viewControllers.last!)
        } else {
            let vcString = String(describing: currentViewController)
            fatalError("Not a modal, no navigation controller: can't navigate back from \(vcString)")
        }
        return subject.asObservable()
            .take(1)
            .ignoreElements()
    }
    
    func currentNavigationController() -> UINavigationController {
        return self.currentNavigation
    }
    
    func currentView() -> UIViewController {
        return self.currentViewController
    }
    
    func currentScene() -> Scene {
        guard let scene = self.listScene.last else {
            return .none
        }
        return scene
    }
}
