//
//  SettingsTableDataSource.swift
//  gitap
//
//  Created by Koichi Sato on 12/25/16.
//  Copyright © 2016 Koichi Sato. All rights reserved.
//

import UIKit

class SettingsTableViewDataSource: NSObject {
    var stateController: StateController
    
    let cellInfo: [Dictionary<String, Array<String>>] =
        [
    ["sectionName": ["account"],
     "items": ["push notification","github auth"]
            ],
    ["sectionName": ["gitap"],
     "items": ["feedback", "follow on twitter", "upgrades", "donate", "app version"]
            ]
    ]
    
    init(tableView: UITableView, stateController: StateController) {
        self.stateController = stateController
        super.init()
        tableView.dataSource = self
        tableView.register(ReposTableViewCell.self, forCellReuseIdentifier: reposCellId)
    }
}

extension SettingsTableViewDataSource: UITableViewDataSource {
    // setting sections
    // acount, gitap
    // account section -> push notifictaion, github auth
    // gitap -> feedback, follow on twitter, upgrades, donate, app version
    // feedbackシステムは工夫したい。星を選ばせて、3star以下だったらアプリ制作者にメールを飛ばすように。4以上だったらApp Storeにも流すようにしたい。
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cellInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = cellInfo[indexPath.section]["items"]?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (cellInfo[section]["items"]?.count)!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return cellInfo[section]["sectionName"]?[0]
    }
}
