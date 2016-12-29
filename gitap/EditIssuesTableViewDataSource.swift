//
//  EditIssuesTableViewDataSource.swift
//  gitap
//
//  Created by Koichi Sato on 12/28/16.
//  Copyright © 2016 Koichi Sato. All rights reserved.
//

import UIKit

let editIssuesId = "EditIssuesTableViewCell"

class EditIssuesTableViewDataSource: NSObject {
    var stateController: StateController
    let cellTitles = ["Title", "Responsible", "MileStone", "Labels"]
    
    init(tableView: UITableView, stateController: StateController) {
        self.stateController = stateController
        super.init()
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: editIssuesId)
    }
}

extension EditIssuesTableViewDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: editIssuesId, for: indexPath as IndexPath)
        if indexPath.section == 0 {
            cell.textLabel?.text = cellTitles[indexPath.row]
        } else if indexPath.section == 1 {
            cell.textLabel?.text = "Description"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 4
        case 1:
            return 1
        default:
            return 1
        }
    }
}

