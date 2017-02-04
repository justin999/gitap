//
//  PhotosTableViewDataSource.swift
//  gitap
//
//  Created by Koichi Sato on 2017/02/04.
//  Copyright © 2017 Koichi Sato. All rights reserved.
//

import UIKit

class PhotosTableViewDataSource: NSObject {

    var stateController: StateController
    
    init(tableView: UITableView, stateController: StateController) {
        self.stateController = stateController
        super.init()
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: issesDetailId)
    }
}

extension PhotosTableViewDataSource: UITableViewDataSource {

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

}
