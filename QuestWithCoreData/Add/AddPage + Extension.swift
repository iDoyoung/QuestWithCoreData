//
//  AddPage + Extension.swift
//  QuestWithCoreData
//
//  Created by ido on 2021/04/04.
//

import UIKit


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
            let newTask = Task(context: viewModel.dataManager.context)
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
