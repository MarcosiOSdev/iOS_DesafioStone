//
//  FactCellViewModel.swift
//  DesafioStone
//
//  Created by Marcos Felipe Souza on 28/11/19.
//  Copyright © 2019 Marcos Felipe Souza. All rights reserved.
//

import RxSwift
import RxCocoa
import Action

enum FactCellFontType {
    case normal, largeTitle
}

class FactCellViewModel {
    private var factModel: FactModel
    let disposeBag = DisposeBag()
    init(model: FactModel, sharedAction: CocoaAction) {
        self.factModel = model
        self.sharedAction = sharedAction
        self.binding()
    }
    
    //MARK: output
    var sharedAction: CocoaAction
    
    //MARK: - OUTPUT
    lazy var title = BehaviorRelay<String>(value: self.factModel.title)
    lazy var tag = BehaviorRelay<String>(value: self.factModel.tag)
    var font: BehaviorRelay<FactCellFontType> {
        let fontType: FactCellFontType = self.factModel.title.count > 80 ? .normal : .largeTitle
        return BehaviorRelay<FactCellFontType>(value: fontType)
    }
    var loadInProgress = BehaviorRelay(value: false)
    
 
    //MARK: INPUT
    var onTappedButton = PublishRelay<Void>()
    
    func binding() {
        
        onTappedButton.asObservable().subscribe { _ in
            self.loadInProgress.accept(true)
            print("TAPPED")
            self.sharedAction.execute().asObservable().subscribe({ event in
                switch event {
                case .completed:
                    self.loadInProgress.accept(false)
                    print("GOTTEM HERE")
                default: break
                }
            }).disposed(by: self.disposeBag)
        }.disposed(by: disposeBag)
    }
}
