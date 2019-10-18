//
//  FactsViewController.swift
//  DesafioStone
//
//  Created by Marcos Felipe Souza on 24/07/19.
//  Copyright © 2019 Marcos Felipe Souza. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources


class FactsViewController: UIViewController, BindableType {
    
    @IBOutlet weak var factsCollectionView: UICollectionView! {
        didSet {
            self.factsCollectionView.register(FactCollectionViewCell.nib,
                                              forCellWithReuseIdentifier: FactCollectionViewCell.reuseCell)
            if let layout = self.factsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.estimatedItemSize = CGSize(width: factsCollectionView.bounds.width - 16, height: CGFloat(10))
            }
        }
    }
    
    var viewModel: FactsViewModel!
    var bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
    }
    
    func configureNavigationBar() {        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: nil, action: nil)
    }
    
    
    func bindViewModel() {

        viewModel.facts
            .asObservable()
            .skip(1)
            .filter { $0.count > 0}
            .bind(to: self.factsCollectionView.rx.items(cellIdentifier: FactCollectionViewCell.reuseCell, cellType: FactCollectionViewCell.self)){
                [weak self] row, model, cell in
                guard let strongSelf = self  else { return }
                cell.configure(with: model, action: strongSelf.viewModel.sharedButton(fact: model))
            }
            .disposed(by: bag)
        
        
        viewModel.title
            .bind(to: self.rx.title)
            .disposed(by: bag)
        
        navigationItem.rightBarButtonItem?.rx.action = viewModel.searchViewButtonTapped
    }

}
