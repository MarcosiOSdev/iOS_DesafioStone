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
        case suggestionTitleSearchScene = "SUGGESTION_TITLE_IN_SEARCH_SCENE"
        case searchPlaceholderSearchScene = "SEARCH_PLACEHOLDER_IN_SEARCH_SCENE"
        case tapToReturnEmptyCellFact = "TAP_TO_RETURN_EMPTY_CELL_FACT"
        case valueIsEmptyEmptyCellFact = "VALUE_EMPTY_EMPTY_CELL_FACT"
    }
    
    func text(by localizationString: LocalizationString ) -> String{
        return NSLocalizedString(localizationString.rawValue, comment: "...")
    }
    
}
