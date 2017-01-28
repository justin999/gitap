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
//            stateController.presentAlert(title: <#T##String#>, message: <#T##String#>, style: <#T##UIAlertControllerStyle#>, actions: <#T##[UIAlertAction]#>, completion: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)
        }
        
//        stateController.dismiss(animated: true, completion: nil)
        stateController.dismiss(animated: true) {
            if let vc = self.stateController.originalViewController as? CreateIssuesViewController {
                vc.repoButton.titleLabel?.text = self.stateController.selectedRepo?.full_name
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
