//
//  ViewController.swift
//  QuestWithCoreData
//
//  Created by ido on 2021/02/04.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    let dataManager = DataManager.dataManager
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }

    var epic = [Quest]()
    var high = [Quest]() // change name
    var normal = [Quest]()
   
    func loadQueset() {
        let request: NSFetchRequest<Quest> = Quest.fetchRequest()
        do {
            let quests = try dataManager.context.fetch(request)
            epic = quests.filter { $0.priority == 1 }
            high = quests.filter { $0.priority == 2 }
            normal = quests.filter { $0.priority == 3 }
        } catch {
            print("Error:\(error)")
        }
    }

}

extension ViewController: UITableViewDelegate {
    
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numbers = 0
        switch section {
        case 1:
            numbers = epic.count
        case 2:
            numbers = high.count
        case 3:
            numbers = normal.count
        default:
            print("Error!")
        }
        return numbers
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        return cell
    }
 
}



class TableViewCell: UITableViewCell {
    
}

class CollectionViewCell: UICollectionViewCell {
    
}
