//
//  TaskListCell.swift
//  QuestWithCoreData
//
//  Created by ido on 2021/04/03.
//

import UIKit
import MarqueeLabel

class CellOfTasks: UITableViewCell {
    
    let dataManager = DataManager.dataManager
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var checkBox: UIView!
    
    @IBOutlet weak var taskTitle: MarqueeLabel!
    
    func updateCell(index: Int) {
        checkBox.layer.borderWidth = 2
        if #available(iOS 13.0, *) {
            checkBox.layer.borderColor = UIColor.label.cgColor
        } else {
            checkBox.layer.borderColor = UIColor.black.cgColor
        }
        
        let task = dataManager.tasks[index]
//        taskTitle.text = task.content
//        if #available(iOS 13.0, *) {
//            taskTitle.textColor = .label
//        } else {
//            taskTitle.textColor = .black
//        }
//        taskTitle.pauseInterval = 3.5
//        taskTitle.scrollSpeed = 30
//        taskTitle.textAlignment = .left
//        taskTitle.labelSpacing = 35
//        taskTitle.fadeLength = 12

        
        if task.isDone {
            doneButton.isSelected = true
        } else {
            doneButton.isSelected = false
        }
        
    }
    
}
