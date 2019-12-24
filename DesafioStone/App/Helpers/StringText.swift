//
//  StringText.swift
//  DesafioStone
//
//  Created by Marcos Felipe Souza on 28/07/19.
//  Copyright © 2019 Marcos Felipe Souza. All rights reserved.
//

import Foundation

class StringText {
    
    fileprivate init() {}
    static let sharing = StringText()
    
    enum LocalizationString: String {
        case titleFactScene = "TITLE_FACT_SCENE"
        case titleSearchFacts = "TITLE_SEARCH_FACTS"
        case tagUncategorized = "UNCATEGORIZED_FACT_TAG"
        case defaultError = "ERROR_DEFAULT"
    }
    
    func text(by localizationString: LocalizationString ) -> String{
        return NSLocalizedString(localizationString.rawValue, comment: "...")
    }
    
}
