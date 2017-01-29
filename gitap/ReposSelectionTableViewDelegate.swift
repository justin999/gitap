//
//  ReposSelectionTableViewDelegate.swift
//  gitap
//
//  Created by Koichi Sato on 1/28/17.
//  Copyright © 2017 Koichi Sato. All rights reserved.
//

import UIKit

class ReposSelectionTableViewDelegate: NSObject {
    let stateController: StateController
    
    init(tableView: UITableView, stateController: StateController) {
        self.stateController = stateController
        super.init()
        tableView.delegate = self
    }
}

extension ReposSelectionTableViewDelegate: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if let repo = stateController.repos?[indexPath.row] {
            stateController.selectRepo(repo: repo)
        } else {
            print("something went wront in rstvd")
        }
        
        stateController.dismiss(animated: true) {
            if let vc = self.stateController.originalViewController as? CreateIssuesViewController {
                vc.repoButton.titleLabel?.text = self.stateController.selectedRepo?.full_name
                vc.repoButton.setNeedsDisplay()
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
}
