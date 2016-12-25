//
//  FeedsTableViewDataSource.swift
//  gitap
//
//  Created by Koichi Sato on 12/24/16.
//  Copyright © 2016 Koichi Sato. All rights reserved.
//

import UIKit

let feedsCellId = "FeedsTableViewCell"

class FeedsTableViewDataSource: NSObject {
    var stateController: StateController
    
    init(tableView: UITableView, stateController: StateController) {
        self.stateController = stateController
        super.init()
        tableView.dataSource = self
        tableView.register(FeedsTableViewCell.self, forCellReuseIdentifier: feedsCellId)
    }
}

extension FeedsTableViewDataSource: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return Utils.getViewFromNib(feedsCellId) as! UITableViewCell
    }
    
}
