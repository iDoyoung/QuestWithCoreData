//
//  EditViewController.swift
//  QuestWithCoreData
//
//  Created by ido on 2021/02/04.
//

import UIKit
import CoreData

class EditViewController: UIViewController {
    
    let dataManager = DataManager.dataManager
    
    var tasks = [Task]()
    var quests = [Quest]()
    
//    var currentQuest : Quest? {
//        didSet {
//            
//        }
//    }
    
    
    @IBOutlet weak var tittleText: UITextField!
    @IBOutlet weak var taskText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func addTask(_ sender: UIButton) {
        let newTask = Task(context: dataManager.context)
        newTask.id = Int32(tasks.endIndex)
        newTask.content = taskText.text
        newTask.isDone = false
        tasks.append(newTask)
        dataManager.save()
    }
    
    @IBAction func saveQuest(_ sender: UIButton) {
        let newQuest = Quest(context: dataManager.context)
        newQuest.id = Int32(quests.endIndex)
        newQuest.title = tittleText.text
        newQuest.isDone = false
        newQuest.memo = nil
        newQuest.isPinned = false
        newQuest.hasDeadLine = nil
        quests.append(newQuest)
        dataManager.save()
        // 뒤로가기
    }
    
//    func loadTasks(with request: NSFetchRequest<Task> = Task.fetchRequest(), predicate: NSPredicate? = nil) {
//
//        let questPredicate = NSPredicate(format: "parentQuest.name MATCHES %@", currentQuest!.id)
//
//            if let addtionalPredicate = predicate {
//                request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [questPredicate, addtionalPredicate])
//            } else {
//                request.predicate = questPredicate
//            }
//
//
//            do {
//                tasks = try dataManager.context.fetch(request)
//            } catch {
//                print("Error fetching data from context \(error)")
//            }
//
//        }
    
    
}
