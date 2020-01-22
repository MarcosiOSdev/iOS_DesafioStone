//
//  FactsViewController.swift
//  DesafioStone
//
//  Created by Marcos Felipe Souza on 24/07/19.
//  Copyright © 2019 Marcos Felipe Souza. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources


class FactsViewController: UIViewController, BindableType {
    
    @IBOutlet weak var factsCollectionView: UICollectionView! {
        didSet {
            self.factsCollectionView.register(FactCollectionViewCell.nib,
                                              forCellWithReuseIdentifier: FactCollectionViewCell.reuseCell)
            
            self.factsCollectionView.register(ErrorFactCollectionViewCell.nib,
                                              forCellWithReuseIdentifier: ErrorFactCollectionViewCell.reuseCell)
            
            self.factsCollectionView.register(EmptyFactCollectionViewCell.nib,
                                              forCellWithReuseIdentifier: EmptyFactCollectionViewCell.reuseCell)
            
            if let layout = self.factsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                let width = UIScreen.main.bounds.width - 32
                layout.estimatedItemSize = CGSize(width: width, height: CGFloat(10))
                layout.itemSize = UICollectionViewFlowLayoutAutomaticSize
            }
        }
    }
    
    var viewModel: FactsViewModel!
    var disposedBag = DisposeBag()
    private let _shareFact = PublishRelay<FactModel>()
    private var cellSelected: FactCollectionViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavigationBar()
    }
    
    func sharedButton(fact: FactModel, cell: FactCollectionViewCell) -> CocoaAction {
        return CocoaAction {
            self.cellSelected = cell
            self._shareFact.accept(fact)
            return Observable.empty()
        }
    }
}

//MARK: - Binding UI ViewModel - 
extension FactsViewController {
    func bindViewModel() {
        self.bindToCollection()
        self.bindNavigation()
        self.bindSharing()
    }
    
    private func bindNavigation() {
        self.viewModel.output.title
            .drive(self.rx.title)
            .disposed(by: disposedBag)
        
        self.navigationItem.rightBarButtonItem?.rx
            .tap
            .bind(to: viewModel.input.searchViewButtonTapped)
            .disposed(by: disposedBag)
        
    }
    
    private func bindSharing() {
        self._shareFact
            .bind(to: viewModel.input.sharedFact)
            .disposed(by: disposedBag)
        
        self.viewModel.output.finishedShareFact
            .asObservable()
            .subscribe { event in
                guard let isLoading = event.element, let cell = self.cellSelected else { return }
                cell.isLoading = isLoading
            }.disposed(by: self.disposedBag)
    }
    
    private func bindToCollection() {
        self.viewModel.output.facts
            .asObservable()
            .filter { $0.count > 0}
            .bind(to: self.factsCollectionView.rx.items) { [weak self] collectionView, index, element in
                guard let self = self else { return UICollectionViewCell() }
                let cell = self.setupCell(in: collectionView, index: index, cellType: element)
                return cell
            }
            .disposed(by: disposedBag)
        
        self.factsCollectionView.rx
            .itemSelected
            .map { self.factsCollectionView.cellForItem(at: $0) }
            .filter { $0 is ErrorFactCollectionViewCell || $0 is EmptyFactCollectionViewCell }
            .subscribe({ _ in
                self.viewModel.input
                    .reloadEvent
                    .onNext(())
            })
            .disposed(by: disposedBag)
    }
}

//MARK: - Setups View -
extension FactsViewController {
    
    private func configureNavigationBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: nil, action: nil)
    }
    
    private func setupCell(in collectionView: UICollectionView, index: Int, cellType: FactsTableViewCellType) -> UICollectionViewCell {
        let indexPath = IndexPath(item: index, section: 0)
        switch cellType {
        case .normal(let factModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FactCollectionViewCell.reuseCell, for: indexPath) as? FactCollectionViewCell else {
                return UICollectionViewCell()
            }
            let sharedAction = self.sharedButton(fact: factModel, cell: cell)
            cell.configure(with: factModel,
                           sharedAction: sharedAction)
            
            return cell
            
        case .error(let message):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ErrorFactCollectionViewCell.reuseCell, for: indexPath) as? ErrorFactCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.errorMessageLabel.text = message
            return cell
            
        case .empty:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmptyFactCollectionViewCell.reuseCell, for: indexPath) as? EmptyFactCollectionViewCell else {
                return UICollectionViewCell()
            }
            return cell
        }
    }
}
