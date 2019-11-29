//
//  Scene.swift
//  DesafioStone
//
//  Created by Marcos Felipe Souza on 24/07/19.
//  Copyright © 2019 Marcos Felipe Souza. All rights reserved.
//

import UIKit

/// Telas do app
enum Scene {
    case facts
    case sharedLink(title: String, link: URL)
}

extension Scene {
    
    var chuckNorrisAPI: ChuckNorrisAPIType {
       return ChuckNorrisAPI()
    }
    
    
    func dependencyInjection(coordinator: CoordinatorType) -> UIViewController {
        switch self {
        case .facts:
            let viewModel = FactsViewModel(chuckNorrisAPI: self.chuckNorrisAPI,
                                           coordinator: coordinator)
            var viewController = FactsViewController.loadFromNib()
            viewController.bindViewModel(to: viewModel)
            return viewController
        
        case .sharedLink(let title, let link):
            let objectsToShare: [Any] = [link, title]
            let viewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            viewController.completionWithItemsHandler = { activityType, bollean, anyes, error in
                
            }
            return viewController
        }
    }
}
