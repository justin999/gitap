//
//  IssueDetailTableViewDataSource.swift
//  gitap
//
//  Created by Koichi Sato on 12/30/16.
//  Copyright © 2016 Koichi Sato. All rights reserved.
//

import UIKit

let issesDetailId = "IssueDetailTableViewCell"

class IssueDetailTableViewDataSource: NSObject {
    var stateController: StateController
    
    init(tableView: UITableView, stateController: StateController) {
        self.stateController = stateController
        super.init()
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: issesDetailId)
    }
}

extension IssueDetailTableViewDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return ""
        case 1:
            return "Activity"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        let cell = tableView.dequeueReusableCell(withIdentifier: issesDetailId, for: indexPath as IndexPath)
        let cell = UITableViewCell()
        cell.textLabel?.text = "hogehoge"
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 5
        case 1:
            return 1
        default:
            return 0
        }
    }
}
