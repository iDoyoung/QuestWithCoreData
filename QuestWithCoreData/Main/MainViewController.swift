//
//  ViewController.swift
//  QuestWithCoreData
//
//  Created by ido on 2021/02/04.
//

import UIKit
import CoreData
import UserNotifications

class MainViewController: UIViewController {
    
    @IBOutlet weak var searchBarBG: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet var showButtons: [UIButton]!
    @IBOutlet var showButtonsBG: [UIView]!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel = Main.main
    
    var selectedQuests: [Quest] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    // view will appear 마다 selectedQuest 값 설정해야함...
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setRightNavButton()
        
        viewModel.loadData()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = footerView
        tableView.layer.cornerRadius = 20
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundView = UIImageView(image: UIImage(named: "dark_wood_board"))
        
        searchTextField.delegate = self
        searchTextField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        viewModel.overTime()
        
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
            
            //TODO: 애니메이션효과 따로 만들기
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
                selectedQuests = viewModel.epic
                seletedTitle = "Epic \(viewModel.epic.count)."
            case showButtons[1]:
                selectedQuests = viewModel.rare
                seletedTitle = "Rare \(viewModel.rare.count)."
            case showButtons[2]:
                selectedQuests = viewModel.common
                seletedTitle = "Common \(viewModel.common.count)."
            case showButtons[3]:
                selectedQuests = viewModel.hasDeadLine
                seletedTitle = "Deadline \(viewModel.hasDeadLine.count)."
            default:
                selectedQuests = viewModel.uncompleted
                seletedTitle = "All \(viewModel.uncompleted.count)."
            }
            
        } else {
            selectedQuests = viewModel.uncompleted
            seletedTitle = "All \(viewModel.uncompleted.count)"
            for button in showButtons {
                button.isSelected = false
                button.superview!.backgroundColor = .clear
            }
        }
        
    }

    
    func showButtonUI() {
        for button in showButtons {
            button.superview?.layer.cornerRadius = button.bounds.height * 0.5
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        selectedQuests = viewModel.uncompleted
        seletedTitle = "All \(selectedQuests.count)"
        for button in showButtons {
            button.isSelected = false
            button.superview!.backgroundColor = .clear
        }
    }

    var seletedTitle = ""
    
   
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
        viewModel.pinned[buttonTag].isPinned = false
        viewModel.saveData()
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
        viewModel.saveData()
        collectionView.reloadData()
    }
    
}
