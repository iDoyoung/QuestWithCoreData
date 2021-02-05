//
//  DataManager.swift
//  QuestWithCoreData
//
//  Created by ido on 2021/02/05.
//

import CoreData

class DataManager {
    
    static let dataManager = DataManager()
    
    init() { }
    
    lazy var persistentContainer: NSPersistentContainer = {
    
        let container = NSPersistentContainer(name: "QuestModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
               
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
              
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    var context: NSManagedObjectContext {
        self.persistentContainer.viewContext
    }
    
    func save() {
        do {
            try context.save()
            print("Succes save data")
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
//    func load() {
//        do {
//            dataArray = try context.fetch(Hello.fetchRequest())
//            dataArray.forEach {
//                print("\($0.name!): Hello \($0.country!)!")
//            }
//        } catch {
//            print("Error: \(error.localizedDescription)")
//        }
//    }
//    
//    func reset() {
//        for data in dataArray {
//            context.delete(data)
//        }
//        save()
//    }
}
