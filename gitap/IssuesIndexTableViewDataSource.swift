//
//  IssuesIndexTableViewDataSource.swift
//  gitap
//
//  Created by Koichi Sato on 12/30/16.
//  Copyright © 2016 Koichi Sato. All rights reserved.
//

import UIKit

let issesIndexId = "IssuesIndexTableViewCell"

class IssuesIndexTableViewDataSource: NSObject {
    var stateController: StateController
    
    init(tableView: UITableView, stateController: StateController) {
        self.stateController = stateController
        super.init()
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: issesIndexId)
    }
}

extension IssuesIndexTableViewDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: issesIndexId, for: indexPath as IndexPath)
        let cell = UITableViewCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
}
