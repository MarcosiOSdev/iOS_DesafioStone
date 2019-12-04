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
import Action


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
                layout.estimatedItemSize = CGSize(width: factsCollectionView.bounds.width - 16, height: CGFloat(10))
            }
        }
    }
    
    var viewModel: FactsViewModel!
    var disposedBag = DisposeBag()
    
    private let _shareFact =  BehaviorRelay<FactModel>(value: FactModel.empty)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
    }
    
    private var cellSelected: FactCollectionViewCell?
    
    func configureNavigationBar() {        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: nil, action: nil)
    }
    
    
    func bindViewModel() {

        viewModel.output.facts
            .asObservable()
            .skip(1)
            .filter { $0.count > 0}
            .bind(to: self.factsCollectionView.rx.items) { [weak self] tableView, index, element in
                
                guard let strongSelf = self else { return UICollectionViewCell() }
                
                let indexPath = IndexPath(item: index, section: 0)
                switch element {
                case .normal(let factModel):
                    guard let cell = tableView.dequeueReusableCell(withReuseIdentifier: FactCollectionViewCell.reuseCell, for: indexPath) as? FactCollectionViewCell else {
                        return UICollectionViewCell()
                    }
                    let sharedAction = strongSelf.sharedButton(fact: factModel, cell: cell)
                    cell.configure(with: factModel,
                                   sharedAction: sharedAction)
                    
                    return cell
                
                case .error(let message):
                    guard let cell = tableView.dequeueReusableCell(withReuseIdentifier: ErrorFactCollectionViewCell.reuseCell, for: indexPath) as? ErrorFactCollectionViewCell else {
                        return UICollectionViewCell()
                    }
                    cell.errorMessageLabel.text = message
                    return cell
                
                case .empty:
                    guard let cell = tableView.dequeueReusableCell(withReuseIdentifier: ErrorFactCollectionViewCell.reuseCell, for: indexPath) as? ErrorFactCollectionViewCell else {
                        return UICollectionViewCell()
                    }
                    return cell
                }
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
        
        viewModel.output.title
            .drive(self.rx.title)
            .disposed(by: disposedBag)
        
        
        navigationItem.rightBarButtonItem?.rx
            .tap
            .bind(to: viewModel.input.searchViewButtonTapped)
            .disposed(by: disposedBag)
        
        _shareFact
            .bind(to: viewModel.input.sharedFact)
            .disposed(by: disposedBag)
        
        self.viewModel.output.finishedShareFact
            .asObservable()
            .subscribe { event in
                guard let isLoading = event.element, let cell = self.cellSelected else { return }
                isLoading ? cell.showLoading() : cell.hideLoading()
        }.disposed(by: self.disposedBag)
    }
    
    func sharedButton(fact: FactModel, cell: FactCollectionViewCell) -> CocoaAction {
        return CocoaAction {
            self.cellSelected = cell
            self._shareFact.accept(fact)
            return Observable.empty()
        }
    }

}
