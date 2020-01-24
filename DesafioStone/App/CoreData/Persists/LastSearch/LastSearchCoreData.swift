//
//  LastSearchCoreData.swift
//  DesafioStone
//
//  Created by Marcos Felipe Souza on 22/01/20.
//  Copyright © 2020 Marcos Felipe Souza. All rights reserved.
//

import Foundation
import RxSwift
import CoreData

class LastSearchCoreData: LastSearchCoreDataType {
    var coreDataStack = CoreDataStack()
    var managedContext: NSManagedObjectContext {
       self.coreDataStack.managedContext
    }
    
    func save(category: CategoryModel) {
        let last = LastSearchCDModel(context: self.managedContext)
        last.category = category.value
        last.createDate = Date()
        let number = NSNumber(value: category.uid)
        last.uid = number.int64Value
        coreDataStack.saveContext()
    }
    
    func fetch() -> Observable<[CategoryModel]> {
        return Observable<[CategoryModel]>.create { [weak self] observer in
             
            let fetchRequest: NSFetchRequest = LastSearchCDModel.fetchRequest()
            fetchRequest.fetchLimit = 5
            let highestSortDescriptor = NSSortDescriptor(key: "createDate", ascending: false)
            fetchRequest.sortDescriptors = [highestSortDescriptor]
            
            do {
                let categoriesCD = try self?.coreDataStack.managedContext.fetch(fetchRequest)
                if let categoriesModel = self?.mapper(to: categoriesCD ?? []) {
                    observer.onNext(categoriesModel)
                }
            } catch {
                observer.onNext([])
            }
            
            return Disposables.create()
        }
    }
    
    private func mapper(to lastSearchCDModels: [LastSearchCDModel] ) -> [CategoryModel] {
        
        var tempList = [CategoryModel]()
        lastSearchCDModels.forEach { categoryCD in
            let number = NSNumber(value: categoryCD.uid)
            let categoryModel = CategoryModel(uid: number.intValue,
                                              value: categoryCD.category ?? "")
            
            tempList.append(categoryModel)
        }        
        return tempList
    }
    
}
