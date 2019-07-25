//
//  SceneTransitionType.swift
//  DesafioStone
//
//  Created by Marcos Felipe Souza on 24/07/19.
//  Copyright © 2019 Marcos Felipe Souza. All rights reserved.
//

import Foundation

///Define o tipo da Tela
enum SceneTransitionType {
    
    /// Tela principal.
    case root
    
    /// Adicionar uma tela.
    case push
    
    /// Presenter uma modal.
    case modal
}
