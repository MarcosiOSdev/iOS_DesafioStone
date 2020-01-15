//
//  LastSuggestionTableView.swift
//  DesafioStone
//
//  Created by Marcos Felipe Souza on 15/01/20.
//  Copyright © 2020 Marcos Felipe Souza. All rights reserved.
//

import UIKit

class PastSearchesView: UIView {
    
    static let cellID = "cellID"
    
    var headerLabel: UILabel = {
        let view = UILabel()
        view.text = "Past Searches: "
        view.font = UIFont.OpenSans(.semibold, size: 18)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var pastSearchesTableView: UITableView = {
        let view = UITableView()
        view.register(UITableViewCell.self, forCellReuseIdentifier: PastSearchesView.cellID)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
}

//MARK: - Lifecycle UI -
extension PastSearchesView {
    override func layoutSubviews() {
        self.setupHeaderLabel()
        self.setupPastSearchesTableView()
        super.layoutSubviews()
    }
}

//MARK: - Setup UI -
extension PastSearchesView {
    
    private func setupHeaderLabel() {
        self.addSubview(self.headerLabel)
        NSLayoutConstraint.activate([
            self.headerLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16), //Section
            self.headerLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.headerLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
    
    private func setupPastSearchesTableView() {
        self.addSubview(self.pastSearchesTableView)
        NSLayoutConstraint.activate([
            self.pastSearchesTableView.topAnchor.constraint(equalTo: self.headerLabel.topAnchor, constant: 8), //Section
            self.pastSearchesTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.pastSearchesTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
}
