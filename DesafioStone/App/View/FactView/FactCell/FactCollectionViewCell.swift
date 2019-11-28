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
    
    var viewModel: FactCellViewModel!
    var bag = DisposeBag()
    
    override func prepareForReuse() {
        viewModel = nil
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
    
    func configure(with viewModel: FactCellViewModel) {
        self.viewModel = viewModel
        
        self.viewModel.title
            .asObservable()
            .map { $0 }
            .bind(to: self.valueLabel.rx.text)
            .disposed(by: self.bag)
        
        self.viewModel.tag
            .asObservable()
            .map { $0 }
            .bind(to: self.tagLabel.rx.text)
            .disposed(by: self.bag)
        
        
        self.viewModel.loadInProgress
            .asDriver(onErrorJustReturn: true)
            .map {
                $0 ? self.loading.startAnimating() : self.loading.stopAnimating()                
            }
            .drive()
            .disposed(by: self.bag)
        
        
        
        
//        self.viewModel.onShowLoading
//            .map {
//                self.loading.isHidden = $0
//
//            }
//            .subscribe()
//            .disposed(by: self.bag)
        
        
//        self.shareButton.rx.action = viewModel.sharedAction
        
        self.shareButton.rx.tap
            .asObservable()
            .bind(to: viewModel.onTappedButton)
            .disposed(by: self.bag)
        
        self.viewModel.font
            .asObservable()
            .map {$0}
            .subscribe { [weak self] event in
                if let element = event.element {
                    self?.valueLabel.adjustsFontForContentSizeCategory = true
                    
                    switch element {
                    case .normal:
                        self?.setupNormalTitle()
                    case .largeTitle:
                        self?.setupLargeTitle()
                    }
                }
            }
            .disposed(by: self.bag)
        
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
