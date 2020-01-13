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
    
    //MARK: - UIViews -
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
    
    var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = true
        scrollView.isDirectionalLockEnabled = true        
        return scrollView
    }()
    
    var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.backgroundColor = .blue
        return stackView
    }()
        
    var viewModel: SearchFactsViewModel!
    var disposeBag = DisposeBag()
}

//MARK: - UI Lifecycle -
extension SearchFactsViewController {
    override func viewDidLoad() {
        self.setupUIs()
    }
}

//MARK: - Setup -
extension SearchFactsViewController {
    
    private func setupUIs() {
        self.setupSelf()
        self.setupScrollView()
        self.setupStackView()
    }
    
    private func setupSelf() {
        self.view.backgroundColor = .white
    }
    
    private func setupScrollView() {
        self.view.addSubview(self.scrollView)
        
//        self.scrollView.contentSize.width = self.view.frame.width
        
        let topAnchor: NSLayoutYAxisAnchor
        if #available(iOS 11.0, *) {
            topAnchor = view.safeAreaLayoutGuide.topAnchor
        } else {
            topAnchor = topLayoutGuide.bottomAnchor
        }
        NSLayoutConstraint.activate([
            self.scrollView.topAnchor.constraint(equalTo: topAnchor),
            self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
//            self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.scrollView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            self.scrollView.heightAnchor.constraint(equalTo: self.view.heightAnchor)
            //self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    private func setupStackView() {
        self.scrollView.addSubview(self.stackView)
        NSLayoutConstraint.activate([
            self.stackView.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 8),
            self.stackView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 8),
            self.stackView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor, constant: -8),
            self.stackView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor),
        ])
        
        self.addArrangedSearchTextField()
        self.addArrangedLineView()
        self.addArrangedSuggestionView()
    }
    
    private func addArrangedSearchTextField() {
        self.stackView.addArrangedSubview(self.searchTextField)
        NSLayoutConstraint.activate([
            self.searchTextField.leadingAnchor.constraint(equalTo: self.stackView.leadingAnchor),
            self.searchTextField.trailingAnchor.constraint(equalTo: self.stackView.trailingAnchor),
            self.searchTextField.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    private func addArrangedLineView() {
        self.stackView.addArrangedSubview(self.lineView)
        NSLayoutConstraint.activate([
            self.lineView.trailingAnchor.constraint(equalTo: self.stackView.trailingAnchor),
            self.lineView.leadingAnchor.constraint(equalTo: self.stackView.leadingAnchor),
            self.lineView.heightAnchor.constraint(equalToConstant: 2.0),
        ])
    }
    
    private func addArrangedSuggestionView() {
        self.stackView.addArrangedSubview(self.suggestionView)
        self.suggestionView.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
}

//MARK: - Binding Views -
extension SearchFactsViewController {
    func bindViewModel() {
        self.searchTextField.rx
            .controlEvent(.editingDidEndOnExit)
            .asObservable()
            .subscribe(onNext: { _ in
                debugPrint("Clicou aqui \(self.searchTextField.text)")
            }).disposed(by: self.disposeBag)
        
        self.viewModel.output
            .suggestionSearch
            .asObservable()
            .bind(to: self.suggestionView.suggestionFactsCollectionView.rx.items)
                { collectionView, index, element in
                    let indexPath = IndexPath(row: index, section: 0)
                    let cell = collectionView
                        .dequeueReusableCell(withReuseIdentifier: SuggestionFactsCollectionViewCell.reuseCellID,
                                         for: indexPath) as! SuggestionFactsCollectionViewCell
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
        
        self.suggestionView.headerLabel.text = "Suggestions -- Colocar no String --"
    }
}
