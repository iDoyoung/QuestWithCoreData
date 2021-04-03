//
//  HistoryViewController.swift
//  QuestWithCoreData
//
//  Created by ido on 2021/02/19.
//

import UIKit

class HistoryViewController: UIViewController {
    
    let viewModel = History.shared
    let dataManager = DataManager.dataManager
    var textField = UITextField()
    let datePicker = UIDatePicker()
    
    var firstSectionIndexs: [Quest] = [] {
        didSet {
            self.tableView.reloadData()
            updateUI()
            print(firstSectionIndexs.count)
        }
    }
    
    var secondSectionIndexs: [Quest] = [] {
        didSet {
            self.tableView.reloadData()
            print(secondSectionIndexs.count)
        }
    }
    
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var searchBarBG: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var numberOfCompletedEpic: UILabel!
    @IBOutlet weak var numberOfCompletedRare: UILabel!
    @IBOutlet weak var numberOfCompletedCommon: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func showUncomplited(_ sender: Any) {
        if !secondSectionIndexs.isEmpty {
            DispatchQueue.main.async {
                let indexPath = IndexPath(row: 0, section: 1)
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }
    
    func setSerchBarUI() {
        searchBarBG.layer.borderWidth = 1
        searchBarBG.layer.borderColor = UIColor.darkGray.cgColor
        searchBarBG.layer.cornerRadius = searchBarBG.bounds.size.height * 0.5
        searchTextField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
    }
    
    func updateUI() {
        numberOfCompletedEpic.text = String(viewModel.completedEpic.count)
        numberOfCompletedRare.text = String(viewModel.completedRare.count)
        numberOfCompletedCommon.text = String(viewModel.completedCommon.count)
    }
    
    func applyDatetextField() {
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date()
        
        let toolBar = UIToolbar()
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneDatePick))
        
        toolBar.setItems([spaceButton, spaceButton, doneButton], animated: true)
        toolBar.sizeToFit()
        textField.placeholder = "DD/MM/YYYY"
        textField.inputAccessoryView = toolBar
        textField.inputView = datePicker
    }
    
    override func viewDidLoad() {
        firstSectionIndexs = viewModel.completedQuest
        secondSectionIndexs = viewModel.failedQuest
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = footerView
        searchTextField.autocorrectionType = .no
        searchTextField.delegate = self
        self.title = "History"
        setSerchBarUI()
        updateUI()
    }
   
    @objc func doneDatePick() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        textField.text = formatter.string(from: datePicker.date)
        
    }
}
