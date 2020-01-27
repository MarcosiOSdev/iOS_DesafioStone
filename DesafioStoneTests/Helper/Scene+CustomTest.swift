//
//  Scene+CustomTest.swift
//  DesafioStoneTests
//
//  Created by Marcos Felipe Souza on 13/12/19.
//  Copyright © 2019 Marcos Felipe Souza. All rights reserved.
//

import Foundation

@testable import DesafioStone

extension Scene: RawRepresentable {
    public typealias RawValue = Int
    public init?(rawValue: Int) {
        switch rawValue {
        case 1: self = .facts
        case 2: self = .sharedLink(title: "", link: URL(string: "")!, completion: nil)
        case 3: self = .searchCategory(completion: nil)
        default: self = .none
        }
    }
    
    public var rawValue: Int {        
        switch self {
        case .none: return 0
        case .facts: return 1
        case .sharedLink: return 2
        case .searchCategory: return 3
        }
    }
    
        
}
