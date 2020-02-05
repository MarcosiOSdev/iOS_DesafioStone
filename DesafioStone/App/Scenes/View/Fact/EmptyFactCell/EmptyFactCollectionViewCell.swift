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
    @IBOutlet weak var resultValueLabel: UILabel!
    @IBOutlet weak var descriptionImageLabel: UILabel!
    
    //MARK: Model
    var model: EmptyFactViewData?
    
    //MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }
    
    override func layoutSubviews() {
        setupUI()
    }
    
    //MARK: Binding ViewData with UIs
    private func setupUI() {
        self.resultValueLabel.text = self.model?.infoMessage
        self.descriptionImageLabel.text = self.model?.descriptionImage
    }
}
