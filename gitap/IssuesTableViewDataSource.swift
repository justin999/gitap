//
//  IssuesTableViewDataSource.swift
//  gitap
//
//  Created by Koichi Sato on 12/30/16.
//  Copyright © 2016 Koichi Sato. All rights reserved.
//

import UIKit

let issesIndexId = "IssuesTableViewCell"

class IssuesTableViewDataSource: NSObject {
    var stateController: StateController
    
    init(tableView: UITableView, stateController: StateController) {
        self.stateController = stateController
        super.init()
        tableView.dataSource = self
        Utils.registerCell(tableView, nibName: String(describing: FeedsTableViewCell.self), cellId: issesIndexId)
    }
}

extension IssuesTableViewDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: issesIndexId, for: indexPath as IndexPath)
        let cell = UITableViewCell()
        cell.textLabel?.text = "issue name"
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
}
