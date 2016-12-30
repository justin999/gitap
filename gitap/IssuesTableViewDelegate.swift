//
//  IssuesTableViewDelegate.swift
//  gitap
//
//  Created by Koichi Sato on 12/30/16.
//  Copyright © 2016 Koichi Sato. All rights reserved.
//

import UIKit

class IssuesTableViewDelegate: NSObject {
    let stateController: StateController
    
    init(tableView: UITableView, stateController: StateController) {
        self.stateController = stateController
        super.init()
        tableView.delegate = self
    }
    
}

extension IssuesTableViewDelegate: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        stateController.pushIssueDetailViewController(inViewController: stateController.viewController, stateController: stateController)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}
