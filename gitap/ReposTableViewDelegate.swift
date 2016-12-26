//
//  ReposTableViewDelegate.swift
//  gitap
//
//  Created by Koichi Sato on 12/25/16.
//  Copyright © 2016 Koichi Sato. All rights reserved.
//

import UIKit

class ReposTableViewDelegate: NSObject {
    let stateController: StateController
    
    init(tableView: UITableView, stateController: StateController) {
        self.stateController = stateController
        super.init()
        tableView.delegate = self
    }
}

extension ReposTableViewDelegate: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        stateController.pushDetailViewController(inViewController: stateController.viewController)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
}
