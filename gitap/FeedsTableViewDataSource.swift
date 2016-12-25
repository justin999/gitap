//
//  FeedsTableViewDataSource.swift
//  gitap
//
//  Created by Koichi Sato on 12/24/16.
//  Copyright © 2016 Koichi Sato. All rights reserved.
//

import UIKit

class FeedsTableViewDataSource: NSObject {
    var stateController: StateController
    
    init(tableView: UITableView, stateController: StateController) {
        self.stateController = stateController
        super.init()
        tableView.dataSource = self
        tableView.register(FeedsTableViewCell.self, forCellReuseIdentifier: "FeedsTableViewCell")
    }
}

extension FeedsTableViewDataSource: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let nib = UINib(nibName: "FeedsTableViewCell", bundle: nil)
        let views = nib.instantiate(withOwner: self, options: nil)
        
        return views[0] as! UITableViewCell
    }
    
}
