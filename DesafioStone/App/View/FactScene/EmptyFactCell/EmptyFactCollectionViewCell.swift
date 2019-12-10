//
//  EmptyFactCollectionViewCell.swift
//  DesafioStone
//
//  Created by Marcos Felipe Souza on 28/11/19.
//  Copyright © 2019 Marcos Felipe Souza. All rights reserved.
//

import UIKit

class EmptyFactCollectionViewCell: BaseFactCell {
    
    static let reuseCell = "EmptyFactCollectionViewCell"
    static var nib: UINib {
        return UINib(nibName: reuseCell, bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }

}
