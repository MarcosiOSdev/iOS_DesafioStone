//
//  LastSearchCoreDataType.swift
//  DesafioStone
//
//  Created by Marcos Felipe Souza on 22/01/20.
//  Copyright © 2020 Marcos Felipe Souza. All rights reserved.
//

import Foundation
import RxSwift

protocol LastSearchCoreDataType: AnyObject {
    func save(category: CategoryModel)
    func update(category: CategoryModel)
    func fetch() -> Observable<[CategoryModel]>
    func containCategory(_ category: String) -> Bool
}
