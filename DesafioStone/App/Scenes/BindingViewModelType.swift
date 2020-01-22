//
//  BindingViewModelType.swift
//  DesafioStone
//
//  Created by Marcos Felipe Souza on 30/11/19.
//  Copyright © 2019 Marcos Felipe Souza. All rights reserved.
//

import Foundation


/// Todas as ViewModels devem implementar esta interface
protocol BindingViewModelType {
    associatedtype UIInput
    associatedtype UIOutput
    
    var input: UIInput { get }
    var output: UIOutput { get }
}
