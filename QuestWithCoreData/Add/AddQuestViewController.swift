//
//  EditViewController.swift
//  QuestWithCoreData
//
//  Created by ido on 2021/02/04.
//

import UIKit
import CoreData

class AddQuestViewController: UIViewController {
    
    let dataManager = DataManager.dataManager
    
    var tasks = [Task]()
    var quests = [Quest]()
    var priority = 3
    
    @IBOutlet var buttonBG: [UIView]!
    @IBOutlet weak var setEpic: UIButton!
    @IBOutlet weak var setRare: UIButton!
    @IBOutlet weak var setCommon: UIButton!
    @IBOutlet weak var deadLineSwitch: UISwitch!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var tittleText: UITextField!
    @IBOutlet weak var taskText: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomLine: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillHideNotification, object: nil)
        tittleText.becomeFirstResponder()
        setRightNavButton()
        quests = dataManager.quests
        setCommon.isSelected = true
        datePicker.addTarget(self, action: #selector(changeDate), for: .valueChanged)
        datePicker.minimumDate = Date()
        datePicker.isEnabled = false
        tableView.delegate = self
        tableView.dataSource = self
        taskText.delegate = self
        tittleText.autocorrectionType = .no
        taskText.autocorrectionType = .no
        self.title = "New Quest"
        for bgView in buttonBG {
            bgView.layer.cornerRadius = bgView.bounds.height * 0.5
        }
    }
    
    let newQuest = Quest(context: DataManager.dataManager.context)
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        if newQuest.title == nil {
            dataManager.delete(object: newQuest)
            for task in tasks {
                dataManager.delete(object: task)
            }
        }
    }
    @IBAction func setDeadLine(_ sender: UISwitch) {
        if sender.isOn {
            datePicker.isEnabled = true
            newQuest.hasDeadLine = datePicker.date
        } else {
            datePicker.isEnabled = false
            newQuest.hasDeadLine = nil
        }
    }
    
    @IBAction func setPriority(_ sender: UIButton) {
        let buttons = [setEpic, setRare, setCommon]
        for button in buttons {
            button!.isSelected = false
            button!.superview!.backgroundColor = .clear
        }
        sender.isSelected = true
        sender.superview!.backgroundColor = sender.currentTitleColor
        
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
        let button = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(saveQuest))
        navigationItem.rightBarButtonItem = button
    }
    
    @objc func saveQuest() {
        guard !tasks.isEmpty else {
            print("task.empty")
            return
        }
        if tittleText.text?.count != 0 {
            newQuest.id = setID(array: quests)
            newQuest.title = tittleText.text
            newQuest.isDone = false
            newQuest.memo = "Memo"
            newQuest.isPinned = false
            newQuest.priority = Int32(self.priority)
            newQuest.progress = 0
            
            for task in tasks {
                task.parentQuset = newQuest
            }
            quests.append(newQuest)
            dataManager.save()
            self.navigationController?.popViewController(animated: true)
        } else {
            print("Set Title")
        }
    }
    
    @objc func changeDate() {
        newQuest.hasDeadLine = datePicker.date
    }
    
    @objc func adjustInputView(noti: Notification) {
        guard let userInfo = noti.userInfo else { return }
        guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        if noti.name == UIResponder.keyboardWillShowNotification {
            let adjustMentHeight = keyboardFrame.height + 8
            bottomLine.constant = adjustMentHeight
        }
    }
    
    func scrollToLastIndex() {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.tasks.endIndex - 1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
}

extension AddQuestViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tasks.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
}

extension AddQuestViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as? TasksTableViewCell else {
            return UITableViewCell()
        }
        cell.taskLabel.text = tasks[indexPath.row].content
        cell.taskLabel.sizeToFit()
        return cell
    }
    
}
extension AddQuestViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == tittleText {
            //TODO : go next textField
        } else if textField == taskText, !taskText.text!.isEmpty {
            let newTask = Task(context: dataManager.context)
            newTask.id = setID(array: tasks)
            newTask.content = taskText.text!
            newTask.isDone = false
            tasks.append(newTask)
            tableView.reloadData()
            taskText.text = ""
            scrollToLastIndex()
        }
        return true
    }
    
}

class TasksTableViewCell: UITableViewCell {
    
    @IBOutlet weak var taskLabel: UILabel!
    
}
