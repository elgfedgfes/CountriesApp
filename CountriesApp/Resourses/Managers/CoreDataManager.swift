//
//  CoreDataManager.swift
//  CountriesApp
//
//  Created by Luis Fernando Sánchez Palma on 09/05/24.
//

import UIKit
import CoreData

enum CoreDataError: Error {
    case ErrorSavingDB
    case ErrorReadingDB
    case ErrorNoFoundInDB
    case ErrorNoData
    case ErrorUIApplicationDelegate
    case ErrorNSEntityDescriptionEntity
}

class CoreDataManager {
    
    func RecentSearchPOST(name: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return completion(.failure(CoreDataError.ErrorUIApplicationDelegate)) }
        let context = appDelegate.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "RecentSearchEntity", in: context) else { return completion(.failure(CoreDataError.ErrorNSEntityDescriptionEntity))}
        let newUser = NSManagedObject(entity: entity, insertInto: context)
        newUser.setValue(name, forKey: "countryName")
        do {
            try context.save()
            completion(.success(true))
        } catch {
            completion(.failure(CoreDataError.ErrorSavingDB))
        }
    }
    
    
    func RecentSearchGET(completion: @escaping (Result<[String], Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return completion(.failure(CoreDataError.ErrorUIApplicationDelegate)) }
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "RecentSearchEntity")
        do {
            let result = try context.fetch(request)
            
            let userInfoArray = result.compactMap { data -> String? in
                guard let userObject = data as? NSManagedObject,
                      let imageName = userObject.value(forKey: "countryName") as? String else {
                    return nil
                }
                return imageName
            }
            
            completion(.success(userInfoArray))
        } catch {
            completion(.failure(CoreDataError.ErrorReadingDB))
        }
    }
        
    func RecentSearchDELETE(name: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return completion(.failure(CoreDataError.ErrorUIApplicationDelegate)) }
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "RecentSearchEntity")
        request.predicate = NSPredicate(format: "countryName == %@", name)
        do {
            let result = try context.fetch(request)
            if let user = result.first as? NSManagedObject {
                context.delete(user)
                try context.save()
                completion(.success(true))
            } else {
                completion(.failure(CoreDataError.ErrorNoFoundInDB))
            }
        } catch {
            completion(.failure(CoreDataError.ErrorReadingDB))
        }
    }
}
