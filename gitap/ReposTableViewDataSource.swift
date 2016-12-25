//
//  ReposTableViewDataSource.swift
//  gitap
//
//  Created by Koichi Sato on 12/25/16.
//  Copyright © 2016 Koichi Sato. All rights reserved.
//

import UIKit

let reposCellId = "ReposTableViewCell"

class ReposTableViewDataSource: NSObject {
    var stateController: StateController
    
    init(tableView: UITableView, stateController: StateController) {
        self.stateController = stateController
        super.init()
        tableView.dataSource = self
        tableView.register(ReposTableViewCell.self, forCellReuseIdentifier: reposCellId)
    }
}

extension ReposTableViewDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return Utils.getViewFromNib(reposCellId) as! UITableViewCell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "public" //private, private members, public, public members, forked
    }
}

