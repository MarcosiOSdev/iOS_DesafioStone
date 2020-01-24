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

class LastSearchCoreData {
    var coreDataStack = CoreDataStack()
    var managedContext: NSManagedObjectContext {
       self.coreDataStack.managedContext
    }
}

//MARK: - CoreDataType Functions -
extension LastSearchCoreData: LastSearchCoreDataType {
    
    func update(category: CategoryModel) {
        let lastSearches = self.lastSearch(with: category.value)
        if let model = lastSearches.first {
            model.createDate = Date()
            self.coreDataStack.saveContext()
        }
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
            let highestSortDescriptor = NSSortDescriptor(key: "createDate", ascending: false)
            
            fetchRequest.fetchLimit = 5
            fetchRequest.sortDescriptors = [highestSortDescriptor]
            
            DispatchQueue.main.async {
                do {
                    let categoriesCD = try self?.coreDataStack.managedContext.fetch(fetchRequest)
                    if let categoriesModel = self?.mapper(to: categoriesCD ?? []) {
                        observer.onNext(categoriesModel)
                    }
                } catch {
                    observer.onNext([])
                }
            }
            return Disposables.create()
        }
    }
    
    func containCategory(_ category: String) -> Bool {
        let fetchCoreData = self.lastSearch(with: category)
        return fetchCoreData.count > 0
    }
}


//MARK: - Aux Functions -
extension LastSearchCoreData {
    
    private func lastSearch(with category: String) -> [LastSearchCDModel] {
        let fetchRequest: NSFetchRequest = LastSearchCDModel.fetchRequest()
        let predicate = self.predicate(with: category)
        
        fetchRequest.predicate = predicate
        fetchRequest.fetchLimit = 1
        do {
            let fetchCoreData = try self.managedContext.fetch(fetchRequest)
            return fetchCoreData
        } catch {
            return []
        }
    }
    
    private func predicate(with category: String) -> NSPredicate {
        return NSPredicate(format: "category == %@", category)
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
