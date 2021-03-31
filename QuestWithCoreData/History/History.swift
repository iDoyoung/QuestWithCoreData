//
//  HistoryViewModel.swift
//  QuestWithCoreData
//
//  Created by ido on 2021/03/28.
//

import Foundation

class History {
    
    static let shared = History()
    
    private init() {    }
    
    let dataManager = DataManager.dataManager
    
    var endQuest: [Quest] {
        dataManager.quests.filter{ $0.isDone == true }
    }
    
    var completedQuest: [Quest] {
        endQuest.filter {
            $0.progress == 100
        }
    }
    
    var failedQuest: [Quest] {
        endQuest.filter {
            $0.progress != 100
        }
    }
    
    var completedEpic: [Quest] {
        completedQuest.filter{ $0.priority == 1}
    }
    
    var completedRare: [Quest] {
        completedQuest.filter{ $0.priority == 2 }
    }
    
    var completedCommon: [Quest] {
        completedQuest.filter{ $0.priority == 3 }
    }
    
}
