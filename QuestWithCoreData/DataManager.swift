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
    
    var tasks = [Task]() {
        didSet {
            tasks.sort {
                $0.id < $1.id
            }
        }
    }
    
    
    var context: NSManagedObjectContext {
        self.persistentContainer.viewContext
    }
    
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
    
    @discardableResult
    func delete(object: NSManagedObject) -> Bool {
        self.context.delete(object)
        print("Succes delete")
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
    
    func dateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    func stringToDate(dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        let date = dateFormatter.date(from: dateString)
        return date!
    }
}
