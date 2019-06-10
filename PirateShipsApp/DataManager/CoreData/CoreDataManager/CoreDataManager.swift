//
//  CoreDataManager.swift
//  PirateShipsApp
//
//  Created by Victor Magalhaes on 15/03/19.
//  Copyright © 2019 Victor. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager: CoreDataProvider {
   
    func saveData(entity: String, data: [[String: Any?]], completion: @escaping (Result<()>) -> Void) {
        
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = delegate.persistentContainer.viewContext
        
        guard let userEntity = NSEntityDescription.entity(forEntityName: entity, in: managedContext) else { return }
        
        data.forEach {
            let newEntity = NSManagedObject(entity: userEntity, insertInto: managedContext)
            newEntity.setValuesForKeys($0 as [String : Any])
        }
        
        do {
            try managedContext.save()
            completion(.succeeded(()))
        } catch {
            completion(.failed("Error saving passed content."))
        }
    }
    
    func deleteAllData(entity: String, completion: @escaping (Result<()>) -> Void) {
        DispatchQueue.main.async {
            guard let delegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let managedContext = delegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
            let request = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try managedContext.execute(request)
                completion(.succeeded(()))
            } catch  {
                completion(.failed("There where an error during removing local data"))
            }
        }
    }
    
    func retrieveAllData<T>(entity: String, completion: @escaping (Result<T>) -> Void) {
      
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = delegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        
        do {
            let fetch = try managedContext.fetch(fetchRequest)
            guard let result = fetch as? [NSManagedObject] else { return }
            completion(.succeeded(result as! T))
        } catch {
            completion(.failed("There where an error during removing local data"))
        }
    }
    
}
