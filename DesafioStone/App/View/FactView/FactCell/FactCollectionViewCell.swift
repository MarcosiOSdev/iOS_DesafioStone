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
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    var bag = DisposeBag()
    
    override func prepareForReuse() {
        shareButton.rx.action = nil
        bag = DisposeBag()
        self.loading.isHidden = true
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
        self.contentView.layer.cornerRadius = self.frame.height / 12
        self.contentView.layer.borderWidth = 0.3
        self.contentView.layer.borderColor = UIColor.gray.cgColor
        self.contentView.layer.masksToBounds = true
    }
    
    func configure(with factModel: FactModel, action: CocoaAction, loadingAction: BehaviorRelay<Bool>) {
        self.valueLabel.text = factModel.title
        self.tagLabel.text = factModel.tag
        self.shareButton.rx.action = action
        self.tagLabel.text = factModel.tag
        _ = loadingAction.asDriver(onErrorJustReturn: true)
            .map {
                self.loading.isHidden = $0
        }
        
        //Regras das fonts
        if factModel.title.count < 80 {
            self.valueLabel.adjustsFontForContentSizeCategory = true
            let customFont = UIFont.boldSystemFont(ofSize: 24)
            if #available(iOS 11.0, *) {
                self.valueLabel.font = UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: customFont)
            } else {
                self.valueLabel.font = customFont
            }
        }
    }
}
