//
//  AppConfiguration.swift
//  DesafioStone
//
//  Created by Marcos Felipe Souza on 25/07/19.
//  Copyright © 2019 Marcos Felipe Souza. All rights reserved.
//

import Foundation

/// InfoPlist pode ler as informacoes no arquivo de .xcconfig para os ambientes (Environment).
struct InfoPlist {
    
    /**
     Retorna o valor da chave do .xcconfig
     
     - Parameters:
     - for: É a key onde pega o valor.
     
     - Throws: Caso não exista a chave mencionada, o error "Invalid or missing Info.plist key:".
     
     - Returns: Retorna um valor do parametro `for`.
     */
    static func value<T>(for key: String) -> T {
        guard let value = Bundle.main.infoDictionary?[key] as? T else {
            fatalError("Invalid or missing Info.plist key: \(key)")
        }
        return value
    }
}
