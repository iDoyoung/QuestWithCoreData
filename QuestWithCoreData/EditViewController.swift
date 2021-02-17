//
//  EditViewController.swift
//  QuestWithCoreData
//
//  Created by ido on 2021/02/04.
//

import UIKit
import CoreData

class EditViewController: UIViewController {
    // data에 완료날짜 추가
    let dataManager = DataManager.dataManager
    
    var tasks = [Task]()
    var quests = [Quest]()
    var priority = 3
    
    @IBOutlet weak var setEpic: UIButton!
    @IBOutlet weak var setRare: UIButton!
    @IBOutlet weak var setCommon: UIButton!
    @IBOutlet weak var deadLineSwitch: UISwitch!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var tittleText: UITextField!
    @IBOutlet weak var taskText: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tittleText.becomeFirstResponder()
        setRightNavButton()
        quests = dataManager.quests
        setCommon.isSelected = true
        tableView.delegate = self
        tableView.dataSource = self
        datePicker.addTarget(self, action: #selector(changeDate), for: .valueChanged)
        datePicker.isEnabled = false
    
    }
    
    let newQuest = Quest(context: DataManager.dataManager.context)
    
    @IBAction func setDeadLine(_ sender: UISwitch) {
        if sender.isOn {
            datePicker.isEnabled = true
            newQuest.hasDeadLine = datePicker.date
            } else {
                datePicker.isEnabled = false
                newQuest.hasDeadLine = nil
            }
    }
    
    @IBAction func addTask(_ sender: UIButton) {
        if !taskText.text!.isEmpty {
            let newTask = Task(context: dataManager.context)
            newTask.id = setID(array: tasks)
            newTask.content = taskText.text!
            newTask.isDone = false
            tasks.append(newTask)
            tableView.reloadData()
            taskText.text = ""
        } else {
            print("")
        }
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
    
    func setID(array: Array<Any>) -> Int32 {
        if array.isEmpty {
            return 0
        } else {
            return (array[array.endIndex - 1] as AnyObject).id + 1
        }
    }
    
    func setRightNavButton() {
        let button = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(saveQuest))
        navigationItem.rightBarButtonItem = button
    }
    
    @objc func saveQuest() {
        newQuest.id = setID(array: quests)
        newQuest.title = tittleText.text
        newQuest.isDone = false
        newQuest.memo = nil
        newQuest.isPinned = false
        newQuest.priority = Int32(self.priority)
        
        for task in tasks {
            task.parentQuset = newQuest
        }
        
        quests.append(newQuest)
        dataManager.save()
        print(newQuest)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func changeDate() {
        newQuest.hasDeadLine = datePicker.date
    }
    
}

extension EditViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tasks.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
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
