//
//  FactCollectionViewCell.swift
//  DesafioStone
//
//  Created by Marcos Felipe Souza on 25/07/19.
//  Copyright © 2019 Marcos Felipe Souza. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class FactCollectionViewCell: BaseFactCell {

    static let reuseCell = "FactCollectionViewCell"
    static var nib: UINib {
        return UINib(nibName: reuseCell, bundle: nil)
    }
    
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
    
    var isLoading: Bool = true {
        didSet {
            isLoading ? showLoading() : hideLoading()
        }
    }
    var factModel: FactModel!
    var bag = DisposeBag()
    
    
    func configure(with factModel: FactModel,
                   sharedAction: AnyObserver<(model: FactModel, cell: FactCollectionViewCell)>) {
        
        self.factModel = factModel
        self.shareButton.rx
            .tap
            .map { (model: self.factModel, cell: self) }
            .bind(to: sharedAction)
            .disposed(by: self.bag)
        self.valueLabel.text = factModel.title
        self.tagLabel.text = factModel.tag
                
        self.valueLabel.adjustsFontForContentSizeCategory = true
        self.factModel.title.count > 80 ? setupNormalTitle() : setupLargeTitle()
    }
   
}

//MARK: - UI Lifecycle -
extension FactCollectionViewCell {
    override func prepareForReuse() {
        self.factModel = nil
        super.prepareForReuse()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupCell()
        self.loadingActivityIndicator.isHidden = true
    }
}

//MARK: - AUX Functions -
extension FactCollectionViewCell {
    private func showLoading() {
        self.shareButton.alpha = 1
        UIView.animate(withDuration: 0.3) {
            self.shareButton.alpha = 0
        }
        UIView.animate(withDuration: 0.3, delay: 0.15, options: .curveEaseInOut, animations: {
            self.loadingActivityIndicator.alpha = 1
        }) { _ in
            self.loadingActivityIndicator.startAnimating()
            self.shareButton.isHidden = true
            self.loadingActivityIndicator.isHidden = false
        }
    }
    
    private func hideLoading() {
        UIView.animate(withDuration: 0.3) {
            self.loadingActivityIndicator.alpha = 0
        }
        UIView.animate(withDuration: 0.3, delay: 0.15, options: .curveEaseInOut, animations: {
            self.shareButton.alpha = 1
        }, completion: {_ in
            self.shareButton.isHidden = false
            self.loadingActivityIndicator.isHidden = true
        })
    }
}

//MARK: - Setups -
extension FactCollectionViewCell {

       private func setupLargeTitle() {
           let customFont = UIFont.OpenSans(.extraBold, size: 22)
           if #available(iOS 11.0, *) {
               self.valueLabel.font = UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: customFont)
           } else {
               self.valueLabel.font = customFont
           }
       }
       
       private func setupNormalTitle() {
           let customFont = UIFont.OpenSans(.regular, size: 16)
           if #available(iOS 11.0, *) {
               self.valueLabel.font = UIFontMetrics(forTextStyle: .title1).scaledFont(for: customFont)
           } else {
               self.valueLabel.font = customFont
           }
       }
}
