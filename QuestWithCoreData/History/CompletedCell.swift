//
//  CompletedCell.swift
//  QuestWithCoreData
//
//  Created by ido on 2021/04/03.
//

import UIKit

class CompletionCell: UITableViewCell {
    
    @IBOutlet weak var priorityEmoji: UIImageView!
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var tasks: UILabel!
    
    @IBOutlet weak var endDate: UILabel!
    
    func updateUI(quest: Quest) {
        title.text = quest.title
        
        switch quest.priority {
        case 1:
            priorityEmoji.image = UIImage(named: "epicQuest")
        case 2:
            priorityEmoji.image = UIImage(named: "rareQuest")
        case 3:
            priorityEmoji.image = UIImage(named: "commonQuest")
        default:
            priorityEmoji.image = UIImage(named: "")
        }
        if quest.progress != 100 {
            self.tasks.text = "\(quest.progress)%"
            endDate.text = ""
        } else {
            self.tasks.text = ""
            endDate.text = ""
        }
    }
}
