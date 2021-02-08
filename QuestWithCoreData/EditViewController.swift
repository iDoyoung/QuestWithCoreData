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
    var priority = 3
    
    @IBOutlet weak var setEpic: UIButton!
    @IBOutlet weak var setRare: UIButton!
    @IBOutlet weak var setCommon: UIButton!
    
    @IBOutlet weak var tittleText: UITextField!
    @IBOutlet weak var taskText: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tittleText.becomeFirstResponder()
        setCommon.isSelected = true
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func addTask(_ sender: UIButton) {
        let newTask = Task(context: dataManager.context)
        newTask.id = Int32(tasks.endIndex)
        newTask.content = taskText.text
        newTask.isDone = false
        dataManager.save()
        tasks.append(newTask)
        tableView.reloadData()
        print(tasks.count)
    }
    
    @IBAction func setPriority(_ sender: UIButton) {
        let buttons = [setEpic, setRare, setCommon]
        for button in buttons {
            button!.isSelected = false
        }
        sender.isSelected = true
        if setEpic.isSelected {
            priority = 1
        } else if setRare.isSelected {
            priority = 2
        } else if setCommon.isSelected {
            priority = 3
        }
        print(priority)
    }
    
    @IBAction func saveQuest(_ sender: UIButton) {
        let newQuest = Quest(context: dataManager.context)
        newQuest.id = Int32(quests.endIndex)
        newQuest.title = tittleText.text
        newQuest.isDone = false
        newQuest.memo = nil
        newQuest.isPinned = false
        newQuest.hasDeadLine = nil
        newQuest.priority = Int32(self.priority)
        quests.append(newQuest)
        dataManager.save()
    }
    
}

extension EditViewController: UITableViewDelegate {
    
}

extension EditViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as? TasksTableViewCell else {
            return UITableViewCell()
        }
        cell.taskLabel.text = tasks[indexPath.row].content
        return cell
    }
    
}

class TasksTableViewCell: UITableViewCell {
    
    @IBOutlet weak var taskLabel: UILabel!
    
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
