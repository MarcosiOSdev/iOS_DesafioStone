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
}

extension Scene {
    func dependencyInjection() -> UIViewController {
        switch self {
        case .facts:
            let viewModel = FactsViewModel()
            var viewController = FactsViewController.loadFromNib()
            viewController.bindViewModel(to: viewModel)
            return viewController
        }
    }
}
