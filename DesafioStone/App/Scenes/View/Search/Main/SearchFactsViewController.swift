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
        let view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var lineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
        return view
    }()
    
    var suggestionView: SuggestionView = {
        let view = SuggestionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var pastSearchesView: PastSearchesView = {
        let view = PastSearchesView()
        view.translatesAutoresizingMaskIntoConstraints = true
        return view
    }()
    
    var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = false
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
        stackView.spacing = 0
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
        let topAnchor: NSLayoutYAxisAnchor
        if #available(iOS 11.0, *) {
            topAnchor = view.safeAreaLayoutGuide.topAnchor
        } else {
            topAnchor = topLayoutGuide.bottomAnchor
        }
        NSLayoutConstraint.activate([
            self.scrollView.topAnchor.constraint(equalTo: topAnchor),
            self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8),
            self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -8),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.scrollView.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -16),
        ])
    }
    
    private func setupStackView() {
        self.scrollView.addSubview(self.stackView)
        NSLayoutConstraint.activate([
            self.stackView.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 16),
            self.stackView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            self.stackView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            self.stackView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor)
        ])
        
        self.addArrangedSearchTextField()
        self.addArrangedLineView()
        self.addArrangedSuggestionView()
        self.addPastSearchesView()
        
    }
    
    private func addArrangedSearchTextField() {
        self.stackView.addArrangedSubview(self.searchTextField)
        NSLayoutConstraint.activate([
            self.searchTextField.leadingAnchor.constraint(equalTo: self.stackView.leadingAnchor),
            self.searchTextField.trailingAnchor.constraint(equalTo: self.stackView.trailingAnchor),
            self.searchTextField.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    private func addArrangedLineView() {
        self.stackView.addArrangedSubview(self.lineView)
        self.lineView.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
    }
    
    private func addArrangedSuggestionView() {
        self.stackView.addArrangedSubview(self.suggestionView)
        self.suggestionView.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    private func addPastSearchesView() {
        self.stackView.addArrangedSubview(self.pastSearchesView)
        self.pastSearchesView.heightAnchor.constraint(equalToConstant: 300).isActive = true
    }
}

//MARK: - Binding Views -
extension SearchFactsViewController {
    func bindViewModel() {
        
        //Inputs
        let inputSearchText = self.searchTextField.rx
            .controlEvent(.editingDidEndOnExit)
            .asObservable()
            .map { self.searchTextField.text ?? "" }
        
        let suggestionSearch = self.suggestionView.suggestionFactsCollectionView
            .rx
            .modelSelected(String.self)
            .map { $0 }
        
        let pastSearch = self.pastSearchesView.pastSearchesTableView
            .rx
            .modelSelected(String.self)
            .map{$0}
        
        let search =
            Observable.from([
                inputSearchText,
                suggestionSearch,
                pastSearch])
                .merge()
            
        search
            .asObservable()
            .bind(to: self.viewModel.input.searchText)
            .disposed(by: self.disposeBag)
        
        search.subscribe { _ in
            self.searchTextField.text = ""
        }.disposed(by: self.disposeBag)
        
        //Outputs
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
        
        self.viewModel.output
            .lastSearch
            .asObservable()
            .filter { $0.count > 0}
            .bind(to: self.pastSearchesView.pastSearchesTableView.rx.items)
                { tableView, index, element in
                    let indexPath = IndexPath(row: index, section: 0)
                    let cell = tableView
                        .dequeueReusableCell(withIdentifier: PastSearchTableViewCell.reuseCell,
                                             for: indexPath) as! PastSearchTableViewCell
                    cell.model = element
                    return cell
            }
            .disposed(by: self.disposeBag)
        
        self.viewModel.output
            .suggestionTitle
            .drive(self.suggestionView.headerLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        self.viewModel.output.title
            .drive(self.rx.title)
            .disposed(by: self.disposeBag)
        
        self.viewModel.output
            .placeholderSearch
            .asObservable()
            .subscribe(onNext: { value in
                self.searchTextField.placeholder = value
            }).disposed(by: self.disposeBag)
        
    }
}
