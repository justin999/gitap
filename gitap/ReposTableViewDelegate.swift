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
        
        var repo: Repo?
        switch indexPath.section {
        case reposSection.privateSection.rawValue:
            repo = stateController.reposDictionary["private"]?[indexPath.row]
        case reposSection.publicSection.rawValue:
            repo = stateController.reposDictionary["public"]?[indexPath.row]
        default:
            repo = nil
        }
        guard let selectedRepo = repo else {
            return
        }
        stateController.selectedRepo = selectedRepo
        let vc = CreateIssuesViewController()
        vc.stateController = stateController
        stateController.viewController.performSegue(withIdentifier: "presentEditIssue", sender: nil)
    }
    
    @objc func newIssueButtonTapped() {
        Utils.addButtonTapped(stateController: stateController)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
}
