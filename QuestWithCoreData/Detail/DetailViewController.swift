//
//  DetailView.swift
//  QuestWithCoreData
//
//  Created by ido on 2021/02/09.
//

import UIKit
import CoreData
import AutoScrollLabel

class DetailViewController: UIViewController {
    //TODO : if isdone memo set not work
    
    // selected
    let dataManager = DataManager.dataManager
    let viewModel = Detail.detail
    
    @IBOutlet weak var questTitle: CBAutoScrollLabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var priorityEmoji: UIImageView!
    @IBOutlet weak var deadLineEmoji: UIImageView!
    @IBOutlet weak var alertDeadLine: UIImageView!
    @IBOutlet weak var tableViewBG: UIView!
    @IBOutlet weak var memoView: UIView!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var deadLine: UILabel!
    @IBOutlet weak var memoLabel: UILabel!
    @IBOutlet weak var memoButton: UIButton!
    
    @IBAction func setMemo(_ sender: UIButton) {
        performSegue(withIdentifier: "memo", sender: self)
    }
    
    var progressValue: Float = 0 {
        didSet {
            progressBar.setProgress(Float(progressValue * 0.01), animated: true)
            if progressBar.progress == 1 {
                viewModel.selectedQuest?.isDone = true

                let animation = CABasicAnimation(keyPath: "transform.scale")
                animation.fromValue = 1.1
                animation.toValue = 1
                animation.duration = 0.5
                progressBar.layer.add(animation, forKey: "scale-layer")
                stateOfDone()
                tableView.reloadData()
            }
        }
    }
    
    func stateOfDone() {
        if viewModel.selectedQuest?.isDone == true {
            memoButton.isEnabled = false
            tableView.alpha = 0.7
        }
    }
    
    func applyMemoUI() {
        memoView.backgroundColor = #colorLiteral(red: 0.9960784314, green: 0.9568627451, blue: 0.631372549, alpha: 1)
        memoView.layer.shadowOffset = .zero
        memoView.layer.shadowRadius = 6
        memoView.layer.shadowOpacity = 0.1
        memoView.layer.masksToBounds = false
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        navigationController?.navigationBar.barTintColor = UIColor(named: "Background")
        self.navigationController?.navigationBar.shadowImage = UIImage()
        stateOfDone()
        applyMemoUI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "memo" {
            let memoVC = segue.destination as! MemoViewController
            memoVC.selectedQuest = self.viewModel.selectedQuest
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateUI()
    }
    
     
    var delegate: QuestDelegate!
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.isNavigationBarHidden = false
        dataManager.loadQueset()
        delegate.updateQuestData()
    }
    
    func updateUI() {
        questTitle.text = viewModel.selectedQuest?.title
        questTitle.font = UIFont.systemFont(ofSize: 75, weight: .thin)
        questTitle.scrollSpeed = 45
        questTitle.pauseInterval = 1.5
        questTitle.textAlignment = .center
        questTitle.fadeLength = 36
        questTitle.labelSpacing = 120
        
        switch viewModel.selectedQuest?.priority {
        case 1:
            progressBar.tintColor = UIColor.systemYellow.withAlphaComponent(0.6)
            priorityEmoji.tintColor = .systemOrange
        case 2:
            progressBar.tintColor = UIColor.systemPurple.withAlphaComponent(0.6)
            priorityEmoji.tintColor = .purple
        case 3:
            progressBar.tintColor = UIColor.systemBlue.withAlphaComponent(0.6)
            priorityEmoji.tintColor = .systemBlue
        default:
            progressBar.tintColor = UIColor.systemBlue
            if #available(iOS 13.0, *) {
                priorityEmoji.tintColor = .label
            } else {
                priorityEmoji.tintColor = .white
            }
        }
        
        alertDeadLine.isHidden = true
        if viewModel.selectedQuest?.hasDeadLine != nil {
            
            let deadline = self.viewModel.deadlineDate
            deadLine.text = deadline
            
            deadLineEmoji.isHidden = false
            deadLine.isHidden = false
            if deadline == dataManager.dateToString(date: Date()) {
                alertDeadLine.isHidden = false
                deadLine.textColor = UIColor(named: "Tint")
            }
        } else {
            deadLineEmoji.isHidden = true
            deadLine.isHidden = true
        }
        memoLabel.text = viewModel.selectedQuest?.memo
        memoLabel.sizeToFit()
    }
  
    
    @objc func doneTask(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        let button = sender.tag
        viewModel.done(sender: button)
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
        
        cell.selectionStyle = .none
        
        cell.updateCell(index: indexPath.row)
        cell.doneButton.tag = indexPath.row
        cell.doneButton.addTarget(self, action: #selector(doneTask(sender:)), for: .touchUpInside)
        
        if viewModel.selectedQuest?.isDone == true {
            cell.doneButton.removeTarget(nil, action: nil, for: .allEvents)
        }
        return cell
    }
}

class CellOfTasks: UITableViewCell {
    let dataManager = DataManager.dataManager
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var checkBox: UIView!
    @IBOutlet weak var taskTitle: CBAutoScrollLabel!
    
    func updateCell(index: Int) {
        checkBox.layer.borderWidth = 2
        if #available(iOS 13.0, *) {
            checkBox.layer.borderColor = UIColor.label.cgColor
        } else {
            checkBox.layer.borderColor = UIColor.black.cgColor
        }
        
        let task = dataManager.tasks[index]
        taskTitle.text = task.content
        if #available(iOS 13.0, *) {
            taskTitle.textColor = .label
        } else {
            taskTitle.textColor = .black
        }
        taskTitle.pauseInterval = 3.5
        taskTitle.scrollSpeed = 30
        taskTitle.textAlignment = .left
        taskTitle.labelSpacing = 35
        taskTitle.fadeLength = 12

        
        if task.isDone {
            doneButton.isSelected = true
        } else {
            doneButton.isSelected = false
        }
        
    }
    
}
