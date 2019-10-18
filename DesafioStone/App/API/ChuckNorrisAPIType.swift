//
//  ChuckNorrisAPIType.swift
//  DesafioStone
//
//  Created by Marcos Felipe Souza on 26/07/19.
//  Copyright © 2019 Marcos Felipe Souza. All rights reserved.
//

import Foundation
import RxSwift

protocol ChuckNorrisAPIType: AnyObject {
    func categories() -> Observable<CategoryResponse>
    func facts(category: CategoryModel?) -> Observable<FactResponse>
    
}
