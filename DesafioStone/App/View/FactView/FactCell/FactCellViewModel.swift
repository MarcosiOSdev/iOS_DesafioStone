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

struct FactCellViewModel {
    
    private var factModel: FactModel
    private var sharedAction: CocoaAction
    let disposeBag = DisposeBag()
    
    init(model: FactModel, sharedAction: CocoaAction) {
        self.factModel = model
        self.sharedAction = sharedAction
        self.initing()
    }
    
    
    //MARK: INPUT
    var onTappedButton: PublishSubject<Void> = .init()
    private let _loadInProgress = BehaviorSubject<Bool>(value: true)
    
    func initing() {
        onTappedButton.asObservable().subscribe { _ in
            self._loadInProgress.onNext(false)
            self.sharedAction.execute().asObservable().subscribe({ event in
                switch event {
                case .completed:
                    self._loadInProgress.onNext(true)
                default: break
                }
            }).disposed(by: self.disposeBag)
        }.disposed(by: disposeBag)
    }
}

//MARK: - OUTPUT
extension FactCellViewModel {
    var title: Driver<String> {
        return Observable<String>.of(self.factModel.title).asDriver(onErrorJustReturn: "")
    }
    var tag: Driver<String> {
        return Observable<String>.of(self.factModel.tag).asDriver(onErrorJustReturn: "")
    }
    
    var font: Driver<FactCellFontType> {
        let fontType: FactCellFontType = self.factModel.title.count > 80 ? .normal : .largeTitle
        return BehaviorRelay<FactCellFontType>(value: fontType).asDriver(onErrorJustReturn: .normal)
    }
    var loadInProgress: Driver<Bool> { return _loadInProgress.asDriver(onErrorJustReturn: false) }
}


