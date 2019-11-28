//
//  FactCollectionViewCell.swift
//  DesafioStone
//
//  Created by Marcos Felipe Souza on 25/07/19.
//  Copyright © 2019 Marcos Felipe Souza. All rights reserved.
//

import UIKit
import Action
import RxSwift
import RxCocoa


class FactCollectionViewCell: UICollectionViewCell {

    static let reuseCell = "FactCollectionViewCell"
    static var nib: UINib {
        return UINib(nibName: reuseCell, bundle: nil)
    }
    
    
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    
    var bag = DisposeBag()
    
    override func prepareForReuse() {
        shareButton.rx.action = nil
        bag = DisposeBag()
        setupCell()
        super.prepareForReuse()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }
    
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
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.frame.height / 12
        
        //Border for Shadow
        self.layer.borderWidth = 0.3
        self.layer.borderColor = UIColor.gray.cgColor
        
        
        //Drawing Shadow
        self.layer.shadowColor = UIColor.gray.cgColor
                
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 1.0
        self.layer.shadowPath =
            UIBezierPath(roundedRect: self.bounds,
                         cornerRadius:self.contentView.layer.cornerRadius).cgPath
    }
    
    func configure(with factModel: FactModel, action: CocoaAction) {
        self.valueLabel.text = factModel.title
        self.tagLabel.text = factModel.tag
        shareButton.rx.action = action
        
        self.valueLabel.text = factModel.title
        self.tagLabel.text = factModel.tag
    }
}
