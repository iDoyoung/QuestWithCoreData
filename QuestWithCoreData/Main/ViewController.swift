//
//  ViewController.swift
//  QuestWithCoreData
//
//  Created by ido on 2021/02/04.
//

import UIKit
import CoreData
import UserNotifications

class ViewController: UIViewController {
    
    @IBOutlet weak var searchBarBG: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet var showButtons: [UIButton]!
    @IBOutlet var showButtonsBG: [UIView]!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionViewBottomLine: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setRightNavButton()
        dataManager.loadQueset()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = footerView
        tableView.layer.cornerRadius = 20
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundView = UIImageView(image: UIImage(named: "dark_wood_board"))
        
        searchTextField.delegate = self
        searchTextField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        overTime()
        searchBarBG.layer.borderWidth = 1
        searchBarBG.layer.borderColor = UIColor.darkGray.cgColor
        applyCorerRadius(view: searchBarBG)
        showButtonUI()
        searchTextField.autocorrectionType = .no
        navigationController?.navigationBar.barTintColor = UIColor(named: "Background")
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        //        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }

    @IBAction func filteringTableView(_ sender: UIButton) {
        
        let otrhers = showButtons.filter {
            $0 != sender
        }
        
        if !sender.isSelected {
            sender.isSelected = true
            for button in otrhers {
                button.isSelected = false
            }
        } else {
            sender.isSelected = false
        }
        
        if sender.isSelected {
            sender.superview!.backgroundColor = sender.currentTitleColor
            let animation = CABasicAnimation(keyPath: "transform.scale")
            animation.fromValue = 1.35
            animation.toValue = 1
            animation.duration = 0.35
            sender.superview!.layer.add(animation, forKey: "scale-layer")
            
            for button in otrhers {
                button.superview!.backgroundColor = .clear
            }
            
            switch sender {
            case showButtons[0]:
                selectedQuests = epic
                seletedTitle = "Epic \(epic.count)."
            case showButtons[1]:
                selectedQuests = rare
                seletedTitle = "Rare \(rare.count)."
            case showButtons[2]:
                selectedQuests = common
                seletedTitle = "Common \(common.count)."
            case showButtons[3]:
                selectedQuests = hasDeadLine
                seletedTitle = "Deadline \(hasDeadLine.count)."
            default:
                selectedQuests = uncompleted
                seletedTitle = "All \(uncompleted.count)."
            }
            
        } else {
            selectedQuests = uncompleted
            seletedTitle = "All \(uncompleted.count)"
            for button in showButtons {
                button.isSelected = false
                button.superview!.backgroundColor = .clear
            }
        }
        
    }

    let dataManager = DataManager.dataManager
    
    func showButtonUI() {
        for button in showButtons {
            button.superview?.layer.cornerRadius = button.bounds.height * 0.5
        }
    }
    
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        dataManager.loadQueset()
        selectedQuests = uncompleted
        seletedTitle = "All \(selectedQuests.count)"
        for button in showButtons {
            button.isSelected = false
            button.superview!.backgroundColor = .clear
        }
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
    
    var seletedTitle = ""
    
    var selectedQuests: [Quest] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    func setRightNavButton() {
        if #available(iOS 13.0, *) {
            let button = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(menuSheet))
            navigationItem.rightBarButtonItem = button
        } else {
            let button = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(menuSheet))
            navigationItem.rightBarButtonItem = button
        }
    }
    
    func goHistory() {
        performSegue(withIdentifier: "showHistory", sender: self)
    }
    
    func addQuest() {
        performSegue(withIdentifier: "showAddOrEdit", sender: self)
    }
    
    func headerTitle() -> UIView {
        let title = UILabel()
        title.text = self.seletedTitle
        title.textColor = .black
        title.font = UIFont.boldSystemFont(ofSize: 20)
        title.textAlignment = .center
        
        if #available(iOS 13.0, *) {
            title.backgroundColor = .systemBackground
        } else {
            title.backgroundColor = .white
        }
        
        return title
    }
    
   

    @objc func menuSheet() {
        let alert = UIAlertController(title: .none, message: .none, preferredStyle: .actionSheet)
        let goHistory = UIAlertAction(title: "History", style: .default) { _ in
            self.goHistory()
        }
        let addQuest = UIAlertAction(title: "Add quest", style: .default) { (_) in
            self.addQuest()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(goHistory)
        alert.addAction(addQuest)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    func showDetail(select: Quest) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        destinationVC.viewModel.selectedQuest = select
        destinationVC.delegate = self
        let navDestinationVC = UINavigationController(rootViewController: destinationVC)
        present(navDestinationVC, animated: true, completion: nil)
    }
    
    func overTime() {
        let today = Date()
        for quest in hasDeadLine {
            if quest.hasDeadLine! < today {
                quest.isDone = true
            }
        }
        dataManager.loadQueset()
    }
    
    func applyCorerRadius(view: UIView) {
        view.layer.cornerRadius = view.bounds.size.height * 0.5
    }
    
    func setLabelBGSize(label: UILabel) {
        switch label.text!.count {
        case 1:
            label.bounds.size.width = label.bounds.size.height
        case 2:
            label.bounds.size.width = label.bounds.size.height * 1.5
        case 3:
            label.bounds.size.width = label.bounds.size.height * 2
        default:
            label.bounds.size.width = 120
        }
    }
    
    @objc func unpinPinnedQuest(sender: UIButton) {
        let buttonTag = sender.tag
        pinned[buttonTag].isPinned = false
        dataManager.save()
        collectionView.reloadData()
        tableView.reloadData()
    }
    
    @objc func pinQuest(sender: UIButton) {
        let buttonTag = sender.tag
        sender.isSelected = !sender.isSelected
        if sender.isSelected == true {
            selectedQuests[buttonTag].isPinned = true
        } else if sender.isSelected == false {
            selectedQuests[buttonTag].isPinned = false
        }
        dataManager.save()
        collectionView.reloadData()
    }
}


extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showDetail(select: selectedQuests[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let alert = UIAlertController(title: "Give up", message: "You did not complete quest. \nAre you going to give up?", preferredStyle: .alert)
            let deleteAction = UIAlertAction(title: "Give up", style: .destructive) { (_) in
                let quest = self.selectedQuests[indexPath.row]
                quest.isDone = true
                self.dataManager.save()
                self.selectedQuests = self.uncompleted
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            alert.addAction(deleteAction)
            present(alert, animated: true, completion: nil)
        }
    }
}

extension ViewController: UITableViewDataSource {
        
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        self.headerTitle()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedQuests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        
        cell.selectionStyle = .none
        let cellOfQuest = selectedQuests[indexPath.row]
        cell.updateCellUI(quest: cellOfQuest)
        cell.pinButton.tag = indexPath.row
        cell.pinButton.addTarget(self, action: #selector(pinQuest(sender:)), for: .touchUpInside)
        return cell
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pinned.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as? CollectionViewCell else {
            return UICollectionViewCell()
        }
        let quest = pinned[indexPath.item]
        cell.updateCollectionViewUI(quest: quest)
        cell.pinButton.tag = indexPath.item
        cell.pinButton.addTarget(self, action: #selector(unpinPinnedQuest(sender:)), for: .touchUpInside)
        cell.contentView.backgroundColor = UIColor(named: "Background")
        
        return cell
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let questOfDeadLine = pinned[indexPath.item]
        showDetail(select: questOfDeadLine)
    }
    
}



extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let searching = textField.text
    
        var searchedQuest: [Quest] {
            uncompleted.filter { $0.title!.contains(searching!) }
        }
        
        if !textField.text!.isEmpty {
            selectedQuests = searchedQuest
            seletedTitle = "Searched \(selectedQuests.count)"
            //tableView.reloadData()
            self.view.endEditing(true)
        } else {
            self.view.endEditing(true)
        }
        return true
    }
}

extension ViewController: QuestDelegate {
    func updateQuestData() {
        viewWillAppear(true)
        selectedQuests = uncompleted
    }
}



class TableViewCell: UITableViewCell {
    @IBOutlet weak var questTitle: UILabel!
    @IBOutlet weak var progress: UILabel!
    @IBOutlet weak var tasksLabel: UILabel!
    
    @IBOutlet weak var priorityImage: UIImageView!
    
    @IBOutlet weak var pinButton: UIButton!
    @IBOutlet weak var deadLineDate: UILabel!
    
    
    func updateCellUI(quest: Quest) {
        
        let dataManager = DataManager.dataManager
        
        questTitle.text = quest.title
        progress.text = "\(quest.progress)%"
        dataManager.loadTasks(select: quest)
        let tasks = dataManager.tasks
        if !tasks.isEmpty {
        tasksLabel.text = "\(tasks[0].content!) and \(tasks.count - 1) others"
        }
        if quest.isPinned == true {
            pinButton.isSelected = true
        } else if quest.isPinned == false {
            pinButton.isSelected = false
        }
        
        switch quest.priority {
        case 1:
            priorityImage.image = UIImage(named: "epicQuest")
        case 2:
            priorityImage.image = UIImage(named: "rareQuest")
        case 3:
            priorityImage.image = UIImage(named: "commonQuest")
        default:
            priorityImage.image = nil
        }
        
        if quest.hasDeadLine != nil {
            deadLineDate.isHidden = false
            let deadLine = dataManager.dateToString(date: quest.hasDeadLine!)
            deadLineDate.text = "Until \(deadLine)"
            let today = dataManager.dateToString(date: Date())
            if deadLine == today {
                deadLineDate.text = "Until Today!"
                deadLineDate.textColor = UIColor(named: "Tint")
            }
        } else {
            deadLineDate.isHidden = true
        }
    }
    
}

class CollectionViewCell: UICollectionViewCell {
    
    let dataManager = DataManager.dataManager
    
    @IBOutlet weak var priorityMark: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var percentageOfProgress: UILabel!
    @IBOutlet weak var taskOfQuest: UILabel!
    
    @IBOutlet weak var pinButton: UIButton!
    
    func updateCollectionViewUI(quest: Quest) {
        title.text = quest.title
        percentageOfProgress.text = "\(quest.progress)%"
        dataManager.loadTasks(select: quest)
        let tasks = dataManager.tasks
        if tasks.count >= 3 {
            taskOfQuest.text = "\(tasks[0].content!) \n\(tasks[1].content ?? "") \n\(tasks[2].content ?? "") \n...\(tasks.count - 1) others"
        } else if tasks.count >= 2{
            taskOfQuest.text = "\(tasks[0].content!) \n...\(tasks.count - 1) others"
        } else {
            taskOfQuest.text = "\(tasks[0].content!)"
        }
    }
}
