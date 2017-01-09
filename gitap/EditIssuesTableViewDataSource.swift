//
//  EditIssuesTableViewDataSource.swift
//  gitap
//
//  Created by Koichi Sato on 12/28/16.
//  Copyright © 2016 Koichi Sato. All rights reserved.
//

import UIKit

let manageTitleId = "manageTitleCell"
let manageResponsibleId = "manageResponsibleCell"
let manageMilestoneId = "manageMilestoneCell"
let manageLabelsId = "manageLabelsCell"
let manageDescriptionId = "manageDescriptionCell"

class EditIssuesTableViewDataSource: NSObject {
    var stateController: StateController
    
    init(tableView: UITableView, stateController: StateController) {
        self.stateController = stateController
        super.init()
        tableView.dataSource = self
        Utils.registerCell(tableView, nibName: "ManageTitleCell", cellId: manageTitleId)
        Utils.registerCell(tableView, nibName: "ManageResponsibleCell", cellId: manageResponsibleId)
        Utils.registerCell(tableView, nibName: "ManageMilestoneCell", cellId: manageMilestoneId)
        Utils.registerCell(tableView, nibName: "ManageLabelsCell", cellId: manageLabelsId)
        Utils.registerCell(tableView, nibName: "ManageDescriptionCell", cellId: manageDescriptionId)
    }
}

extension EditIssuesTableViewDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                cell = tableView.dequeueReusableCell(withIdentifier: manageTitleId, for: indexPath as IndexPath)
            case 1:
                cell = tableView.dequeueReusableCell(withIdentifier: manageResponsibleId, for: indexPath as IndexPath)
            case 2:
                cell = tableView.dequeueReusableCell(withIdentifier: manageMilestoneId, for: indexPath as IndexPath)
            case 3:
                cell = tableView.dequeueReusableCell(withIdentifier: manageLabelsId, for: indexPath as IndexPath)
            default:
                break
            }
        } else if indexPath.section == 1 {
            cell = tableView.dequeueReusableCell(withIdentifier: manageDescriptionId, for: indexPath as IndexPath)
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

