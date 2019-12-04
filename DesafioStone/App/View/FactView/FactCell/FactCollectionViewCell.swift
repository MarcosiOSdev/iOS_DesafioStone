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


class FactCollectionViewCell: BaseFactCell {

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
    
    
    
    func showLoading() {
        
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
    
    func hideLoading() {        
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
    
    func configure(with factModel: FactModel,
                   sharedAction: CocoaAction) {
        
        self.factModel = factModel
        shareButton.rx.action = sharedAction
        self.valueLabel.text = factModel.title
        self.tagLabel.text = factModel.tag
                
        self.valueLabel.adjustsFontForContentSizeCategory = true
        factModel.title.count > 80 ? setupNormalTitle() : setupLargeTitle()
    }
   
}

//MARK: - Setups
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
