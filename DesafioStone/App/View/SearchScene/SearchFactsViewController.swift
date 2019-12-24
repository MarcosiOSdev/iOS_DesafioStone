//
//  CategorySearchViewController.swift
//  DesafioStone
//
//  Created by Marcos Felipe Souza on 23/12/19.
//  Copyright © 2019 Marcos Felipe Souza. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchFactsViewController: UIViewController, BindableType {
    
    var searchTextField: UITextField = {
        var tv = UITextField()
        tv.placeholder = "Searching ..."
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    var lineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
        return view
    }()
    
    var suggestionView: SuggestionView = {
        let sv = SuggestionView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.backgroundColor = .clear
        return sv
    }()
    
    var viewModel: SearchFactsViewModel!
    var disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        self.view.backgroundColor = .white
        self.view.addSubview(searchTextField)
        self.view.addSubview(lineView)
        self.view.addSubview(suggestionView)
        
        setupConstraints()
    }
    
    func bindViewModel() {
        
        searchTextField.rx.controlEvent(.editingDidEndOnExit).asObservable().subscribe(onNext: { _ in
            print("Clicou aqui 3")
        }).disposed(by: disposeBag)
        
        self.viewModel.output
            .suggestionSearch
            .asObservable()
            .bind(to: self.suggestionView.suggestionFactsCollectionView.rx.items) { collectionView, index, element in
                let indexPath = IndexPath(row: index, section: 0)
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SuggestionFactsCollectionViewCell.reuseCellID, for: indexPath) as! SuggestionFactsCollectionViewCell
                cell.suggestionFact = element
                return cell
            }
            .disposed(by: disposeBag)
        
        self.suggestionView.suggestionFactsCollectionView
            .rx
            .modelSelected(String.self)
            .map { $0 }
            .bind(to: viewModel.input.searchText)
            .disposed(by: disposeBag)
        
        self.suggestionView.headerLabel.text = "Suggestions"
    }
    
    private func setupConstraints() {
        if #available(iOS 11.0, *) {
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        } else {
            searchTextField.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 30).isActive = true
        }
        
        NSLayoutConstraint.activate([
            
            searchTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 32.0),
            searchTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -32.0),
            searchTextField.heightAnchor.constraint(equalToConstant: 50),
            
            lineView.trailingAnchor.constraint(equalTo: searchTextField.trailingAnchor),
            lineView.leadingAnchor.constraint(equalTo: searchTextField.leadingAnchor),
            lineView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 1.0),
            lineView.heightAnchor.constraint(equalToConstant: 2.0),
            
            suggestionView.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: 16),
            suggestionView.leadingAnchor.constraint(equalTo: lineView.leadingAnchor),
            suggestionView.trailingAnchor.constraint(equalTo: lineView.trailingAnchor),
            suggestionView.heightAnchor.constraint(equalToConstant: 200),
            
            ])
    }
    
}
