//
//  CoreDataHelper.swift
//  CoreData-SwiftUI
//
//  Created by Priyanshi Bhikadiya on 19/09/23.
//

import Foundation
import CoreData

class CoreDataHelper {
    static let shared = CoreDataHelper()
    
    var viewContext: NSManagedObjectContext {
        return PersistenceController.shared.container.viewContext
    }
    
    func saveData<T: NSManagedObject>(_ object: T) {
        do {
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchData<T: NSManagedObject>(type: T.Type, entityName: String) -> [T] {
        let fetchRequest = NSFetchRequest<T>(entityName: String(describing: entityName))
        do {
            let results = try viewContext.fetch(fetchRequest)
            return results
        } catch {
            print(error.localizedDescription)
        }
        return []
    }
}
