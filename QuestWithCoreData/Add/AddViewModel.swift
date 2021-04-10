//
//  AddViewModel.swift
//  QuestWithCoreData
//
//  Created by ido on 2021/03/28.
//

import Foundation
import CoreData

class AddViewModel {
    
    init() {    }
    
    static let addViewModel = AddViewModel()
    
    let dataManager = DataManager.dataManager
    
    var quests: [Quest] {
        dataManager.quests
    }
    
    
    func loadData() {
        dataManager.loadQueset()
    }
    
    func saveData() {
        dataManager.save()
    }
    
    func delete(new : NSManagedObject) {
        dataManager.delete(object: new)
    }
     
    
    
}
