//
//  MainPinnedCell.swift
//  QuestWithCoreData
//
//  Created by ido on 2021/04/03.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    let dataManager = DataManager.dataManager
    
    @IBOutlet weak var priorityMark: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var percentageOfProgress: UILabel!
    @IBOutlet weak var taskOfQuest: UILabel!
    
    @IBOutlet weak var pinButton: UIButton!
    
    func updateCollectionViewUI(quest: Quest) {
        title.text = quest.title
        percentageOfProgress.text = "\(quest.progress)%"
        dataManager.loadTasks(select: quest)
        let tasks = dataManager.tasks
        if tasks.count >= 3 {
            taskOfQuest.text = "\(tasks[0].content!) \n\(tasks[1].content ?? "") \n\(tasks[2].content ?? "") \n...\(tasks.count - 1) others"
        } else if tasks.count >= 2{
            taskOfQuest.text = "\(tasks[0].content!) \n...\(tasks.count - 1) others"
        } else {
            taskOfQuest.text = "\(tasks[0].content!)"
        }
    }
}
