//
//  DetailView.swift
//  QuestWithCoreData
//
//  Created by ido on 2021/02/09.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {
    
    let dataManager = DataManager.dataManager
   
    @IBOutlet weak var questLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var priorityEmoji: UIImageView!
    @IBOutlet weak var deadLineEmoji: UIImageView!
    @IBOutlet weak var alertDeadLine: UIImageView!
    
    
    var selectedQuest: Quest? {
        didSet {
            loadTasks()
        }
    }
    
    func loadTasks() {
        dataManager.loadTasks(select: selectedQuest!)
    }
    
    func getPercentage() {
        let completedTasks = dataManager.tasks.filter {
            $0.isDone
        }
        let result = completedTasks.count * (100/dataManager.tasks.count)
        print("Done: \(result)%")
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        getPercentage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateUI()
    }
        
    func updateUI() {
        questLabel.text = selectedQuest?.title
        alertDeadLine.isHidden = true
        if selectedQuest?.hasDeadLine != nil {
            deadLineEmoji.isHidden = false

            if selectedQuest!.hasDeadLine == dataManager.dateToString(date: Date()) {
                alertDeadLine.isHidden = false
            }
        } else {
            deadLineEmoji.isHidden = true
        }
    }
  
    @objc func doneTask(sender: UIButton) {
        let buttonTag = sender.tag
        dataManager.tasks[buttonTag].isDone = !dataManager.tasks[buttonTag].isDone
        dataManager.save()
    }
}

extension DetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataManager.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellOfTasks", for: indexPath) as? CellOfTasks else {
            return UITableViewCell()
        }
        
        cell.taskTitle.text = dataManager.tasks[indexPath.row].content
        cell.doneButton.tag = indexPath.row
        cell.doneButton.addTarget(self, action: #selector(doneTask(sender:)), for: .touchUpInside)
        
        return cell
    }
}

class CellOfTasks: UITableViewCell {
    
    @IBOutlet weak var taskTitle: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    
    
}
