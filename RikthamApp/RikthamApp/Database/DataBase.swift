//
//  DataBase.swift
//  RikthamApp
//
//  Created by Lakshminaidu on 26/3/2022.
//

import Foundation
import UIKit
import CoreData

final class Database {
    static let shared = Database()
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "RikthamApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

typealias BusinessDB = Database

extension BusinessDB {
    func save(business: Business) {
        let context = persistentContainer.viewContext
        guard let  businessDB = NSEntityDescription.insertNewObject(forEntityName: "BusinessDBModel", into: context) as? BusinessDBModel else {
            return
        }
        businessDB.id = business.id
        businessDB.businessName = business.name
        businessDB.address = business.fullAddress
        businessDB.rating = Double(business.rating ?? 0)
        businessDB.price = business.price
        businessDB.phone = business.phone
        businessDB.imageUrl = business.imageURL
        businessDB.city = business.city
        businessDB.date = Date()
        do {
            try context.save()
            print("Data saved!!!")
        }
        catch {
            print("Error Occured during saving data!!!")
        }
    }
    
    func fetchData() -> [Business] {
        var visitedData = [BusinessDBModel]()
        let context = persistentContainer.viewContext
        do {
            let req = BusinessDBModel.fetchRequest()
            let dateSort = NSSortDescriptor(key:"date", ascending: false)
            req.sortDescriptors = [dateSort]
            visitedData = try context.fetch(req)
        }
        catch {
            print("Error while feteching data!!!!")
        }
        return visitedData.map{Business.prepare(with: $0)}
    }
}

extension Business {
    static func prepare(with dbModel: BusinessDBModel?) -> Business {
        return  Business(id: dbModel?.id ?? UUID().uuidString, name: dbModel?.businessName, rating: Double(dbModel?.rating ?? 0.0), price: dbModel?.price, phone: dbModel?.phone, categories: nil, imageURL: dbModel?.imageUrl, location: Location(city: dbModel?.city, country: nil, address2: nil, address3: nil, state: nil, address1: nil, zipCode: nil, displayAddress: dbModel?.address?.components(separatedBy: ",")), distance: nil)
    }
}
