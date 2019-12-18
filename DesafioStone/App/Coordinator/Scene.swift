//
//  Scene.swift
//  DesafioStone
//
//  Created by Marcos Felipe Souza on 24/07/19.
//  Copyright © 2019 Marcos Felipe Souza. All rights reserved.
//

import UIKit
import RxSwift
import Action

/// Telas do app
enum Scene {
    case facts
    case sharedLink(title: String, link: URL, completion: CocoaAction?)
    case searchCategory
    
    /// JUST USING IN TEST
    case none
}

extension Scene {
    
    var chuckNorrisAPI: ChuckNorrisAPIType {
       return ChuckNorrisAPI()
    }
    
    
    func dependencyInjection(coordinator: CoordinatorType) -> UIViewController {
        switch self {
        case .facts, .none:
            let viewModel = FactsViewModel(chuckNorrisAPI: self.chuckNorrisAPI,
                                           coordinator: coordinator)
            var viewController = FactsViewController.loadFromNib()
            viewController.bindViewModel(to: viewModel)
            return viewController
        
        case .sharedLink(let title, let link, let completion):
            let objectsToShare: [Any] = [link, title]
            let viewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            viewController.completionWithItemsHandler = { activityType, bollean, anyes, error in
                completion?.execute()                
            }
            return viewController
        case .searchCategory:
            return UIViewController()
        }
    }
}
