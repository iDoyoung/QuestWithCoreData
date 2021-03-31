//
//  MemoViewController.swift
//  QuestWithCoreData
//
//  Created by ido on 2021/02/20.
//

import UIKit

class MemoViewController: UIViewController {
    
    let dataManager = DataManager.dataManager
    
    @IBOutlet weak var memoTextView: UITextView!
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        memoTextView.becomeFirstResponder()
        memoTextView.autocorrectionType = .no
        updateMemo()
        applyMemoUI()
        navigationController?.navigationBar.tintColor = UIColor(named: "Tint")
        navigationController?.navigationBar.barTintColor = UIColor(named: "Background")
        setNavRightButton()
    }
    
    func applyMemoUI() {
        memoTextView.backgroundColor = #colorLiteral(red: 0.9960784314, green: 0.9568627451, blue: 0.631372549, alpha: 1)
        shadowView.layer.shadowOffset = .zero
        shadowView.layer.shadowRadius = 6
        shadowView.layer.shadowOpacity = 0.1
        shadowView.layer.masksToBounds = false
    }
    
    var selectedQuest: Quest!
    
    func updateMemo() {
        memoTextView.text = selectedQuest.memo ?? ""
    }

    func setNavRightButton() {
        let button = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveMemo))
        navigationItem.rightBarButtonItem = button
    }
    
    @objc func saveMemo() {
        selectedQuest.memo = memoTextView.text
        dataManager.save()
        navigationController?.popViewController(animated: true)
    }
    
    @objc func adjustInputView(noti: Notification) {
        guard let userInfo = noti.userInfo else { return }
        guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as?
                                    NSValue)?.cgRectValue else { return }
        if noti.name == UIResponder.keyboardWillShowNotification {
            let adjustMentHeight = keyboardFrame.height
            bottomConstraint.constant = adjustMentHeight
        }
    }
}

