//
//  TypeMessageWatchOS.swift
//  DesafioStone
//
//  Created by Marcos Felipe Souza on 06/02/20.
//  Copyright © 2020 Marcos Felipe Souza. All rights reserved.
//

import Foundation

protocol TypeMessageWatchOS {
    func message() -> [String : Any]
    
    func error(_ error: Error) -> Void
    
}
