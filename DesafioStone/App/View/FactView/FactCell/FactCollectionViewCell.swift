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
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
    
    var factModel: FactModel!
    var bag = DisposeBag()
    private var _loadInProgress = BehaviorSubject<Bool>(value: false)

    override func prepareForReuse() {
        factModel = nil
        shareButton.rx.action = nil
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
    
    
    
    func configure(with factModel: FactModel,
                   sharedAction: CocoaAction) {
        
        self.factModel = factModel
        shareButton.rx.action = sharedAction
//        shareButton.rx.tap
//            .throttle(1.0, scheduler: MainScheduler.instance)
//            .subscribe(onNext: { _ in sharedAction.accept(factModel) })
//            .disposed(by: bag)
                
        self.valueLabel.text = factModel.title
        self.tagLabel.text = factModel.tag
                
        self.valueLabel.adjustsFontForContentSizeCategory = true
        factModel.title.count > 80 ? setupNormalTitle() : setupLargeTitle()
    }
   
}

//MARK: - Setups
extension FactCollectionViewCell {
    private func setupCell() {
           //rounded the cell
           self.contentView.layer.cornerRadius = self.frame.height / 12
           self.contentView.layer.borderWidth = 0.3
           self.contentView.layer.borderColor = UIColor.gray.cgColor
           self.contentView.layer.masksToBounds = true
       }

       private func setupLargeTitle() {
           let customFont = UIFont.boldSystemFont(ofSize: 24)
           if #available(iOS 11.0, *) {
               self.valueLabel.font = UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: customFont)
           } else {
               self.valueLabel.font = customFont
           }
       }
       
       private func setupNormalTitle() {
           let customFont = UIFont.systemFont(ofSize: 17)
           if #available(iOS 11.0, *) {
               self.valueLabel.font = UIFontMetrics(forTextStyle: .title1).scaledFont(for: customFont)
           } else {
               self.valueLabel.font = customFont
           }
       }
}
