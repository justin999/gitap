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
        
        var repo: Repo?
        switch indexPath.section {
        case reposSection.privateSection.rawValue:
            repo = stateController.reposDictionary["private"]?[indexPath.row]
        case reposSection.publicSection.rawValue:
            repo = stateController.reposDictionary["public"]?[indexPath.row]
        default:
            repo = nil
        }
        
        if let repo = repo {
            stateController.selectRepo(repo: repo)
            
            stateController.dismiss(animated: true) {
                if let vc = self.stateController.originalViewController as? CreateIssuesViewController {
                    vc.repoButton.setTitle(self.stateController.selectedRepo?.full_name, for: .normal)
                }
            }
        } else {
            print("something went wront in rstvd")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
}
