//
//  BaseFactCell.swift
//  DesafioStone
//
//  Created by Marcos Felipe Souza on 03/12/19.
//  Copyright © 2019 Marcos Felipe Souza. All rights reserved.
//

import UIKit

class BaseFactCell: UICollectionViewCell {
    lazy var width: NSLayoutConstraint = {
        let width = contentView.widthAnchor.constraint(equalToConstant: bounds.size.width)
        width.isActive = true
        return width
    }()
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize,
                                          withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
                                          verticalFittingPriority: UILayoutPriority) -> CGSize {
        self.width.constant = bounds.size.width
        return contentView.systemLayoutSizeFitting(CGSize(width: targetSize.width, height: 1))
    }
    
    func setupCell() {
        //rounded the cell
        _ = width.constant
        self.contentView.layer.cornerRadius = self.frame.height / 12
        self.contentView.layer.borderWidth = 0.3
        self.contentView.layer.borderColor = UIColor.gray.cgColor
        self.contentView.layer.masksToBounds = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }
}
