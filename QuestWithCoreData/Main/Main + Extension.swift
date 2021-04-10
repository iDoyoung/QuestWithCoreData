//
//  Main + Extension.swift
//  QuestWithCoreData
//
//  Created by ido on 2021/04/03.
//

import UIKit

extension MainViewController: UITableViewDataSource {
        
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        self.headerTitle()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedQuests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        
        cell.selectionStyle = .none
        let cellOfQuest = selectedQuests[indexPath.row]
        cell.updateCellUI(quest: cellOfQuest)
        cell.pinButton.tag = indexPath.row
        cell.pinButton.addTarget(self, action: #selector(pinQuest(sender:)), for: .touchUpInside)
        return cell
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showDetail(select: selectedQuests[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let alert = UIAlertController(title: "Give up", message: "You did not complete quest. \nAre you going to give up?", preferredStyle: .alert)
            let deleteAction = UIAlertAction(title: "Give up", style: .destructive) { (_) in
                let quest = self.selectedQuests[indexPath.row]
                quest.isDone = true
                self.viewModel.saveData()
                self.selectedQuests = self.viewModel.uncompleted
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            alert.addAction(deleteAction)
            present(alert, animated: true, completion: nil)
        }
    }
}



extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.pinned.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as? CollectionViewCell else {
            return UICollectionViewCell()
        }
        let quest = viewModel.pinned[indexPath.item]
        cell.updateCollectionViewUI(quest: quest)
        cell.pinButton.tag = indexPath.item
        cell.pinButton.addTarget(self, action: #selector(unpinPinnedQuest(sender:)), for: .touchUpInside)
        cell.contentView.backgroundColor = UIColor(named: "Background")
        
        return cell
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let questOfDeadLine = viewModel.pinned[indexPath.item]
        showDetail(select: questOfDeadLine)
    }
    
}



extension MainViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let searching = textField.text
    
        var searchedQuest: [Quest] {
            viewModel.uncompleted.filter { $0.title!.contains(searching!) }
        }
        
        if !textField.text!.isEmpty {
            selectedQuests = searchedQuest
            seletedTitle = "Searched \(selectedQuests.count)"
            //tableView.reloadData()
            self.view.endEditing(true)
        } else {
            self.view.endEditing(true)
        }
        return true
    }
}

extension MainViewController: QuestDelegate {
    func updateQuestData() {
        viewWillAppear(true)
        selectedQuests = viewModel.uncompleted
    }
}
