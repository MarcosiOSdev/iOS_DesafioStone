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

typealias FactSection = AnimatableSectionModel<String, String>

class FactsViewController: UIViewController, BindableType {
    
    @IBOutlet weak var factsCollectionView: UICollectionView! {
        didSet {
            self.factsCollectionView.register(FactCollectionViewCell.nib, forCellWithReuseIdentifier: FactCollectionViewCell.reuseCell)
        }
    }
    
    lazy var dataSource: RxCollectionViewSectionedAnimatedDataSource =
        self.configCollectionView()
    
    var viewModel: FactsViewModel!
    
    var bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ChuckNorrisAPI.categories.subscribe(onNext: { valor in
            print(valor)
        }).disposed(by: bag)
    }
    
    func configCollectionView() -> RxCollectionViewSectionedAnimatedDataSource<FactSection> {
        
        return RxCollectionViewSectionedAnimatedDataSource<FactSection>(
            configureCell: { (dataSource, collectionView, indexPath, model) in
            
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FactCollectionViewCell.reuseCell, for: indexPath) as! FactCollectionViewCell
                
                return cell
        })
        
//        factsCollectionView.rowHeight = UITableViewAutomaticDimension
//        factsCollectionView.estimatedRowHeight = 60
    }
    
    func bindViewModel() {
        let observable: Observable<[FactSection]> = Observable.from(optional: [FactSection(model: "", items: ["Feijao", "Arroz"])])
        
        observable
            .bind(to: self.factsCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
    }

}
