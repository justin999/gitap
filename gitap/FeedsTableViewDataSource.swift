//
//  FeedsTableViewDataSource.swift
//  gitap
//
//  Created by Koichi Sato on 12/24/16.
//  Copyright © 2016 Koichi Sato. All rights reserved.
//

import UIKit

let feedsCellId = "feedCell"

class FeedsTableViewDataSource: NSObject {
    var stateController: StateController
    
    init(tableView: UITableView, stateController: StateController) {
        self.stateController = stateController
        super.init()
        tableView.dataSource = self
        Utils.registerCell(tableView, nibName: String(describing: FeedsTableViewCell.self), cellId: feedsCellId)
    }
}

extension FeedsTableViewDataSource: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let events = stateController.issueEvents {
            return events.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: feedsCellId) as! FeedsTableViewCell
        if let event = stateController.issueEvents?[indexPath.row] {
            cell.setData(event: event)
        }
        return cell

    }
    
}
