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
    var bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
    }
    
    func configureNavigationBar() {        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: nil, action: nil)
    }
    
    
    func bindViewModel() {

        viewModel.factsCell
            .asObservable()
            .skip(1)
            .filter { $0.count > 0}
            .bind(to: self.factsCollectionView.rx.items) { tableView, index, element in
                
                let indexPath = IndexPath(item: index, section: 0)
                switch element {
                case .normal(let cellViewModel):
                    guard let cell = tableView.dequeueReusableCell(withReuseIdentifier: FactCollectionViewCell.reuseCell, for: indexPath) as? FactCollectionViewCell else {
                        return UICollectionViewCell()
                    }
                    cell.configure(with: cellViewModel)
                    return cell
                
                case .error(let message):
                    guard let cell = tableView.dequeueReusableCell(withReuseIdentifier: ErrorFactCollectionViewCell.reuseCell, for: indexPath) as? ErrorFactCollectionViewCell else {
                        return UICollectionViewCell()
                    }
                    cell.isUserInteractionEnabled = false
                    return cell
                
                case .empty:
                    guard let cell = tableView.dequeueReusableCell(withReuseIdentifier: ErrorFactCollectionViewCell.reuseCell, for: indexPath) as? ErrorFactCollectionViewCell else {
                        return UICollectionViewCell()
                    }
                    cell.isUserInteractionEnabled = false
                    return cell
                }
            }
            .disposed(by: bag)
        
        
        viewModel.title
            .bind(to: self.rx.title)
            .disposed(by: bag)
        
        navigationItem.rightBarButtonItem?.rx.action = viewModel.searchViewButtonTapped
    }

}
