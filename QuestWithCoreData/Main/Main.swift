//
//  MainViewModel.swift
//  QuestWithCoreData
//
//  Created by ido on 2021/03/28.
//

import Foundation

struct Main {
    
    let dataManager = DataManager.dataManager
    
    static let main = Main()

    init() {    }
    
    func loadData() {
        dataManager.loadQueset()
    }
    
    func saveData() {
        dataManager.save()
    }
    
    var uncompleted: [Quest] {
        dataManager.quests.filter { $0.isDone == false }
    }
    
    var hasDeadLine: [Quest] {
        uncompleted.filter {
            $0.hasDeadLine != nil
        }
    }
    
    var questsTilToday: [Quest] {
        hasDeadLine.filter {
            dataManager.dateToString(date: $0.hasDeadLine!) == dataManager.dateToString(date: Date())
        }
    }
    
    var epic: [Quest] {
        return uncompleted.filter{ $0.priority == 1 }
    }
    
    var rare: [Quest] {
        uncompleted.filter { $0.priority == 2 }
    }
    
    var common: [Quest] {
        uncompleted.filter { $0.priority == 3 }
    }
    
    var pinned: [Quest] {
        uncompleted.filter { $0.isPinned }
    }

    func overTime() {
        let today = Date()
        for quest in hasDeadLine {
            if quest.hasDeadLine! < today {
                quest.isDone = true
            }
        }
        loadData()
    }
}
