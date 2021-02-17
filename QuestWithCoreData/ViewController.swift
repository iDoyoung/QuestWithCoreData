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
    
    var questsTilToday: [Quest] {
        dataManager.quests.filter { $0.hasDeadLine == Date() }
    }
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataManager.loadQueset()
        setRightNavButton()
        tableView.delegate = self
        tableView.dataSource = self
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }

    var uncompleted: [Quest] {
        dataManager.quests.filter { $0.isDone == false }
    }
    
    var epic: [Quest] {
        uncompleted.filter{ $0.priority == 1 }
    }
    
    var rare: [Quest] {
        uncompleted.filter { $0.priority == 2 }
    }
    
    var common: [Quest] {
        uncompleted.filter { $0.priority == 3 }
    }
   
    func setRightNavButton() {
        let button = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addOrEdit))
        navigationItem.rightBarButtonItem = button
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let destinationVC = segue.destination as! DetailViewController
            
            if let indexPath = tableView.indexPathForSelectedRow, indexPath.section == 0 {
                destinationVC.selectedQuest = epic[indexPath.row]
            } else if let indexPath = tableView.indexPathForSelectedRow, indexPath.section == 1 {
                destinationVC.selectedQuest = rare[indexPath.row]
            } else if let indexPath = tableView.indexPathForSelectedRow, indexPath.section == 2 {
                destinationVC.selectedQuest = common[indexPath.row]
            } else {
                print("?")
            }
        }
    }
    
    @objc func addOrEdit() {
        let storyboard = UIStoryboard(name: "Edit", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "EditViewController")
        let navDestinationVC = UINavigationController(rootViewController: destinationVC)
        present(navDestinationVC, animated: true, completion: nil)
    }
    
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: self)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Set alert")
        }
    }
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return epic.count
        } else if section == 1 {
            return rare.count
        } else if section == 2 {
            return common.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        let section = indexPath.section
        if section == 0 {
            cell.questTitle.text = epic[indexPath.row].title
        } else if section == 1 {
            cell.questTitle.text = rare[indexPath.row].title
        } else if section == 2 {
            cell.questTitle.text = common[indexPath.row].title
        }
        return cell
    }
 
}



class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var questTitle: UILabel!
    @IBOutlet weak var progress: UILabel!
    
    
}

class CollectionViewCell: UICollectionViewCell {
    
}
