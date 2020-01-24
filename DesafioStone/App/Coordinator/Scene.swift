//
//  Scene.swift
//  DesafioStone
//
//  Created by Marcos Felipe Souza on 24/07/19.
//  Copyright © 2019 Marcos Felipe Souza. All rights reserved.
//

import UIKit
import RxSwift

/// Telas do app
enum Scene {
    case facts
    case sharedLink(title: String, link: URL, completion: AnyObserver<String>?)
    case searchCategory(completion: AnyObserver<CategoryModel>)
    
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
                completion?.onNext("")
            }
            return viewController
        case .searchCategory(let completion):
            let viewModel = SearchFactsViewModel(coordinator: coordinator, lastSearchCoreData: LastSearchCoreData())
            viewModel.completion = completion
            var viewController = SearchFactsViewController()
            viewController.bindViewModel(to: viewModel)
            return viewController
        }
    }
}
