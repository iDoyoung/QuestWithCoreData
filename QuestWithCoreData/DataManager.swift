//
//  DataManager.swift
//  QuestWithCoreData
//
//  Created by ido on 2021/02/05.
//
import Foundation
import CoreData

class DataManager {
    
    static let dataManager = DataManager()
    
    init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "QuestModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    var quests = [Quest]()
    var tasks = [Task]()
    
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
    
    func loadQueset() {
        let request: NSFetchRequest<Quest> = Quest.fetchRequest()
        do {
            quests = try context.fetch(request)
            print("Success load.")
        } catch {
            print("Error:\(error)")
        }
    }
    
    func loadAllTasks() {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        do {
            tasks = try context.fetch(request)
            print("Success load.")
        } catch {
            print("Error:\(error)")
        }
    }
    
    func delete(object: NSManagedObject) -> Bool {
        self.context.delete(object)
        do { try context.save()
            return true
        } catch {
            return false
        }
    }

    func loadTasks(select: Quest) {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        do {
            tasks = try context.fetch(request)
            let tasksSelected = tasks.filter { $0.parentQuset!.id == select.id }
            tasks = tasksSelected
        } catch {
            print("Error: \(error)")
        }
    }
    
}
