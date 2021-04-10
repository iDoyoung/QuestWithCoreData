//
//  Detail.swift
//  QuestWithCoreData
//
//  Created by ido on 2021/03/29.
//

import Foundation

struct Detail {
    static let detail = Detail()
    
    init() {    }
    
    var selectedQuest: Quest? {
        didSet {
            loadTasks()
        }
    }
    
    let dataManager = DataManager.dataManager
    
    var progressValue: Float = 0
    
    var tasks: [Task] {
        dataManager.tasks
    }
    
    var deadlineDate: String {
        dataManager.dateToString(date: (selectedQuest?.hasDeadLine!)!)
    }
    
    func loadQuests() {
        dataManager.loadQueset()
    }
    func loadTasks() {
        dataManager.loadTasks(select: selectedQuest!)
    }
    
    mutating func getPercentage() {
        let completedTasks = dataManager.tasks.filter {
            $0.isDone
        }
        let countOfTasks = Double(dataManager.tasks.count)
        let countOfCompleted = Double(completedTasks.count)
        let result = ceil(100/countOfTasks * countOfCompleted)
        selectedQuest?.progress = Int16(result)
        progressValue = Float(result)
    }
   
    mutating func done(sender: Int) {
        dataManager.tasks[sender].isDone = !dataManager.tasks[sender].isDone
        getPercentage()
        dataManager.save()
    }
    
    var today: String {
        dataManager.dateToString(date: Date())
    }
}
