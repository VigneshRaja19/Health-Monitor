//
//  PersistenceManager.swift
//  Health Monitor
//
//  Created by Prabhakar Annavi on 26/02/20.
//  Copyright © 2020 Prabhakar Annavi. All rights reserved.
//

import Foundation
import CoreData

/// A global non-subclassable PersistenceManager to access Core Data.
final class PersistenceManager {

    private init() {}
    static let shared = PersistenceManager()

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Health_Monitor")

//                print("PersistentContainer", container.managedObjectModel, container.name, container.persistentStoreCoordinator)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//                        print("storedescription", storeDescription)
            if let error = error as NSError? {
                fatalError("Unsolved Error \(error.userInfo)")
            }
        })
        return container
    }()

    lazy var context = persistentContainer.viewContext

    func saveContext() {

        let context = persistentContainer.viewContext
        print("SavingInContePercontain")
        if context.hasChanges {
            do {
                print("savingINSaevCOntext")
                try context.save()
                print("successfully saved to core data")
            } catch {
                let error = error as NSError
                fatalError("error \(error)")
            }
        }
    }

}

