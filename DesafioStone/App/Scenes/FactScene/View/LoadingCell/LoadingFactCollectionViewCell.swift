//
//  LoadingFactCollectionViewCell.swift
//  DesafioStone
//
//  Created by Marcos Felipe Souza on 24/01/20.
//  Copyright © 2020 Marcos Felipe Souza. All rights reserved.
//

import UIKit
import Shimmer

class LoadingFactCollectionViewCell: BaseFactCell {

    static let reuseCell = "LoadingFactCollectionViewCell"
    
    static var nib: UINib {
        return UINib(nibName: reuseCell, bundle: nil)
    }
    
    @IBOutlet weak var customContenView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.loading()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.loading()
    }
    
    private func loading() {
        
        let shimmer = FBShimmeringView(frame: self.customContenView.frame)
        shimmer.contentView = customContenView
        
        shimmer.isShimmering = true
        shimmer.layer.cornerRadius = self.frame.height / 12
        shimmer.layer.borderWidth = 0.3
        shimmer.layer.borderColor = UIColor.gray.cgColor
        shimmer.layer.masksToBounds = true
        
        self.addSubview(shimmer)
    }

}
