
//
//  SuggestionFactsCollectionViewCell.swift
//  DesafioStone
//
//  Created by Marcos Felipe Souza on 23/12/19.
//  Copyright © 2019 Marcos Felipe Souza. All rights reserved.
//

import UIKit

class SuggestionFactsCollectionViewCell: UICollectionViewCell {
    
    static let reuseCellID = "suggestionCell"
    
    var suggestionFact: String? {
        didSet {
            self.factLabel.text = suggestionFact
            
        }
    }
    
    private let factLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.OpenSans(.bold, size: 16)
        label.textColor = .white
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.contentView.addSubview(factLabel)
        self.contentView.backgroundColor = UIColor(hexString: "#22A2FF")
        
        self.setupConstraint()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }    
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            factLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            factLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            factLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            factLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            ])
    }
    
}
