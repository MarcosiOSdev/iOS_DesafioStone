//
//  FactRowController.swift
//  br.com.mfelipesp.DesafioStoneWatch Extension
//
//  Created by Marcos Felipe Souza on 04/02/20.
//  Copyright © 2020 Marcos Felipe Souza. All rights reserved.
//

import WatchKit
import Foundation

class FactRowController: NSObject {
    
    
    @IBOutlet var categoryLabel: WKInterfaceLabel!
    @IBOutlet var descriptionLabel: WKInterfaceLabel!
    
    var factModel: FactModel? {
        didSet {
            if let model = self.factModel {
                self.categoryLabel.setText(model.tag)
                self.descriptionLabel.setText(model.title)
            }
        }
    }
}
