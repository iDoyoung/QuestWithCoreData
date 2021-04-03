//
//  History + Extension.swift
//  QuestWithCoreData
//
//  Created by ido on 2021/04/03.
//

import UIKit

extension HistoryViewController: QuestDelegate {
    func updateQuestData() {
    }
}

extension HistoryViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Completed \(firstSectionIndexs.count)"
        } else {
            return "Uncompleted \(secondSectionIndexs.count)"
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return firstSectionIndexs.count
        } else if section == 1 {
            return secondSectionIndexs.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "completionCell", for: indexPath) as? CompletionCell else {
            return UITableViewCell()
        }
        if indexPath.section == 0 {
            cell.updateUI(quest: firstSectionIndexs[indexPath.row])
        } else if indexPath.section == 1 {
            cell.updateUI(quest: secondSectionIndexs[indexPath.row])
        }
        return cell
    }
    
    func showDetail(select: Quest) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        destinationVC.viewModel.selectedQuest = select
        destinationVC.delegate = self
        let navDestinationVC = UINavigationController(rootViewController: destinationVC)
        present(navDestinationVC, animated: true, completion: nil)
    }
}

extension HistoryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            showDetail(select: firstSectionIndexs[indexPath.row])
        } else {
            showDetail(select: secondSectionIndexs[indexPath.row])
        }
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (UIContextualAction, UIView, success: (Bool) -> Void) in
            let alert = UIAlertController(title: "Delete quest", message: "This quest will be deleted.", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let action = UIAlertAction(title: "Delete", style: .destructive) { (_) in
                if indexPath.section == 0 {
                    let quest = self.firstSectionIndexs[indexPath.row]
                    self.dataManager.loadTasks(select: quest)
                    let tasks = self.dataManager.tasks
                    for task in tasks {
                        self.dataManager.delete(object: task)
                    }
                    self.dataManager.delete(object: quest)
                } else {
                    let quest = self.secondSectionIndexs[indexPath.row]
                    self.dataManager.loadTasks(select: quest)
                    let tasks = self.dataManager.tasks
                    for task in tasks {
                        self.dataManager.delete(object: task)
                    }
                    self.dataManager.delete(object: quest)
                }
                self.dataManager.save()
                self.firstSectionIndexs = self.viewModel.completedQuest
                self.secondSectionIndexs = self.viewModel.failedQuest
            }
            alert.addAction(cancel)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
    
        }
        
        let retry = UIContextualAction(style: .normal, title: "Retry") { (UIContextualAction, UIView, success: (Bool) -> Void) in
            
           
            let alert = UIAlertController(title: "Retry quest", message: "If you need to set deadline, choose date.", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: .none)
            let action = UIAlertAction(title: "Retry", style: .destructive) { (action) in
                retryQuest()
            }
            
            alert.addTextField { (alertTextField) in
                self.textField = alertTextField
                self.applyDatetextField()
            }
            alert.addAction(cancel)
            alert.addAction(action)
            
            
            func retryQuest() {
                if indexPath.section == 0 {
                    let quest = self.firstSectionIndexs[indexPath.row]
                    quest.isDone = false
                    self.dataManager.loadTasks(select: quest)
                    let tasks = self.dataManager.tasks
                    tasks[tasks.endIndex - 1].isDone = false
                    
                    let completedTasks = tasks.filter {
                        $0.isDone
                    }
                    let countOfTasks = Double(tasks.count)
                    let countOfCompleted = Double(completedTasks.count)
                    let result = ceil(100/countOfTasks * countOfCompleted)
                    quest.progress = Int16(result)
                    
                    if self.textField.text?.isEmpty == true {
                        quest.hasDeadLine = nil
                    } else {
                        quest.hasDeadLine = self.dataManager.stringToDate(dateString: self.textField.text!)
                    }
                    
                    self.dataManager.save()
                    self.firstSectionIndexs = self.viewModel.completedQuest
                    
                } else {
                    let quest = self.secondSectionIndexs[indexPath.row]
                    quest.isDone = false
                    
                    if self.textField.text?.isEmpty == true {
                        quest.hasDeadLine = nil
                    } else {
                        quest.hasDeadLine = self.dataManager.stringToDate(dateString: self.textField.text!)
                    }
                    self.dataManager.save()
                    self.secondSectionIndexs = self.viewModel.failedQuest
                }
            }
            
            self.present(alert, animated: true, completion: nil)
        }
        
        return UISwipeActionsConfiguration(actions: [delete, retry])
    }
}

extension HistoryViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
            let searching = textField.text
                        
            var searchedByCompleted: [Quest] {
                viewModel.completedQuest.filter {  $0.title!.contains(searching!) }
            }
            
            var searchedByFailed: [Quest] {
                viewModel.failedQuest.filter { $0.title!.contains(searching!) }
            }
            
            if !textField.text!.isEmpty {
                firstSectionIndexs = searchedByCompleted
                secondSectionIndexs = searchedByFailed
                self.view.endEditing(true)
            } else {
                firstSectionIndexs = viewModel.completedQuest
                secondSectionIndexs = viewModel.failedQuest
                self.view.endEditing(true)
            }
        return true
    }
    
}
