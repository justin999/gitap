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
        /*
         let vc = ReposDetailViewController()
         var repo: Repo?
         switch indexPath.section {
         case reposSection.privateSection.rawValue:
         repo = stateController.reposDictionary["private"]?[indexPath.row]
         case reposSection.publicSection.rawValue:
         repo = stateController.reposDictionary["public"]?[indexPath.row]
         default:
         repo = nil
         }
         stateController.selectedRepo = repo
         
         stateController.push(destination: vc, inViewController: stateController.viewController)
         */
        
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
        let vc = RepoWebViewController(url: selectedRepo.url)
        vc.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "new issue", style: .plain, target: self, action: #selector(newIssueButtonTapped))
        stateController.pushWebView(destination: vc, inViewController: stateController.viewController)
    }
    
    @objc func newIssueButtonTapped() {
        Utils.addButtonTapped(stateController: stateController)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
}
