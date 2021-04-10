//
//  Detail + Extension.swift
//  QuestWithCoreData
//
//  Created by ido on 2021/04/03.
//

import UIKit

extension DetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.tasks.count
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
