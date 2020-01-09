//
//  SuggestionView.swift
//  DesafioStone
//
//  Created by Marcos Felipe Souza on 23/12/19.
//  Copyright © 2019 Marcos Felipe Souza. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
class SuggestionView: UIView {

    var headerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.OpenSans(.semibold, size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    var suggestionFactsCollectionView: UICollectionView = {
        let flow = UICollectionViewFlowLayout()
        flow.scrollDirection = .vertical
        flow.itemSize = UICollectionViewFlowLayoutAutomaticSize
        flow.estimatedItemSize = CGSize(width: 35.0, height: 100.0)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flow)
        collectionView.register(SuggestionFactsCollectionViewCell.self,
                                forCellWithReuseIdentifier: SuggestionFactsCollectionViewCell.reuseCellID)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    override func layoutSubviews() {
        self.isUserInteractionEnabled = true
        addSubview(self.suggestionFactsCollectionView)
        addSubview(self.headerLabel)
        
        NSLayoutConstraint.activate([
            
            headerLabel.topAnchor.constraint(equalTo: topAnchor),
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            suggestionFactsCollectionView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 8.0),
            suggestionFactsCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            suggestionFactsCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            suggestionFactsCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            ])        
    }
}
