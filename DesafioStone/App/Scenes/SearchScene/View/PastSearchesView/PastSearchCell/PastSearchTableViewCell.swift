//
//  PastSearchTableViewCell.swift
//  DesafioStone
//
//  Created by Marcos Felipe Souza on 18/01/20.
//  Copyright © 2020 Marcos Felipe Souza. All rights reserved.
//

import UIKit

class PastSearchTableViewCell: UITableViewCell {

    static let reuseCell = "PastSearchTableViewCell"
    
    let pastSearchText: UILabel = {
        let view = UILabel()
        view.font = UIFont.OpenSans(.regular, size: 18)
        view.textColor = UIColor.lightGray
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var model: String?
    
    override func layoutSubviews() {
        guard let model = self.model else { return }
        self.pastSearchText.text = model
        self.addSubview(self.pastSearchText)
        self.setupConstraints()
    }
    
    private func setupConstraints(){
        self.pastSearchText.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5).isActive = true
        self.pastSearchText.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5).isActive = true
        self.pastSearchText.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -5).isActive = true
        self.pastSearchText.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 5).isActive = true
    }

}
