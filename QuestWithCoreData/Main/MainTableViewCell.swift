//
//  MainTableViewCell.swift
//  QuestWithCoreData
//
//  Created by ido on 2021/04/03.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet weak var questTitle: UILabel!
    @IBOutlet weak var progress: UILabel!
    @IBOutlet weak var tasksLabel: UILabel!
    
    @IBOutlet weak var priorityImage: UIImageView!
    
    @IBOutlet weak var pinButton: UIButton!
    @IBOutlet weak var deadLineDate: UILabel!
    
    
    func updateCellUI(quest: Quest) {
        
        let dataManager = DataManager.dataManager
        
        questTitle.text = quest.title
        progress.text = "\(quest.progress)%"
        dataManager.loadTasks(select: quest)
        let tasks = dataManager.tasks
        if !tasks.isEmpty {
        tasksLabel.text = "\(tasks[0].content!) and \(tasks.count - 1) others"
        }
        if quest.isPinned == true {
            pinButton.isSelected = true
        } else if quest.isPinned == false {
            pinButton.isSelected = false
        }
        
        switch quest.priority {
        case 1:
            priorityImage.image = UIImage(named: "epicQuest")
        case 2:
            priorityImage.image = UIImage(named: "rareQuest")
        case 3:
            priorityImage.image = UIImage(named: "commonQuest")
        default:
            priorityImage.image = nil
        }
        
        if quest.hasDeadLine != nil {
            deadLineDate.isHidden = false
            let deadLine = dataManager.dateToString(date: quest.hasDeadLine!)
            deadLineDate.text = "Until \(deadLine)"
            let today = dataManager.dateToString(date: Date())
            if deadLine == today {
                deadLineDate.text = "Until Today!"
                deadLineDate.textColor = UIColor(named: "Tint")
            }
        } else {
            deadLineDate.isHidden = true
        }
    }
    
}
