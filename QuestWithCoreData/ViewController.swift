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
    var quests = [Quest]()
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadQueset()
        setRightNavButton()
        tableView.delegate = self
        tableView.dataSource = self
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }

    var epic = [Quest]()
    var rare = [Quest]()
    var normal = [Quest]()
   
    func loadQueset() {
        let request: NSFetchRequest<Quest> = Quest.fetchRequest()
        do {
            quests = try dataManager.context.fetch(request)
            let uncompleted = quests.filter { $0.isDone == false }
            epic = uncompleted.filter { $0.priority == 1 }
            rare = uncompleted.filter { $0.priority == 2 }
            normal = uncompleted.filter { $0.priority == 3 }
            print("Success load.")
        } catch {
            print("Error:\(error)")
        }
    }
    
    func setRightNavButton() {
        let button = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addOrEdit))
        navigationItem.rightBarButtonItem = button
        
    }
    
    @objc func addOrEdit() {
        let storyboard = UIStoryboard(name: "Edit", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(identifier: "EditViewController")
        present(destinationVC, animated: true, completion: nil)
    }
    
}

extension ViewController: UITableViewDelegate {
    
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return epic.count
        } else if section == 2 {
            return rare.count
        } else {
            return normal.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        let section = tableView.numberOfSections
        if section == 1 {
            cell.questTitle.text = epic[indexPath.row].title
        } else if section == 2 {
            cell.questTitle.text = rare[indexPath.row].title
        } else {
            cell.questTitle.text = normal[indexPath.row].title
        }
        return cell
    }
 
}



class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var questTitle: UILabel!
}

class CollectionViewCell: UICollectionViewCell {
    
}
