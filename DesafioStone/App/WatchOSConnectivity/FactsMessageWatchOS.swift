//
//  FactsMessageWatchOS.swift
//  DesafioStone
//
//  Created by Marcos Felipe Souza on 06/02/20.
//  Copyright © 2020 Marcos Felipe Souza. All rights reserved.
//

import Foundation

struct FactsMessageWatchOS: TypeMessageWatchOS {
    
    var facts: [FactModel]
    
    func message() -> [String : Any] {
        return ["facts": facts]
    }
    
    func error(_ error: Error) -> Void {
        print(error.localizedDescription)
    }
}
