//
//  ReposTableViewDataSource.swift
//  gitap
//
//  Created by Koichi Sato on 12/25/16.
//  Copyright © 2016 Koichi Sato. All rights reserved.
//

import UIKit

let reposCellId = "repoCell"

enum reposSection: Int {
    case privateSection
    case publicSection
    
    static let count = 2
    
    var title: String {
        switch self {
        case .privateSection: return "private"
        case .publicSection:  return "public"
        }
    }
}

class ReposTableViewDataSource: NSObject {
    var stateController: StateController
    
    init(tableView: UITableView, stateController: StateController) {
        self.stateController = stateController
        super.init()
        tableView.dataSource = self
        Utils.registerCell(tableView, nibName: String(describing: ReposTableViewCell.self), cellId: reposCellId)
    }
}

extension ReposTableViewDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return reposSection.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case reposSection.privateSection.rawValue:
            return stateController.privateRepos?.count ?? 0
        case reposSection.publicSection.rawValue:
            return stateController.publicRepos?.count ?? 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reposCellId) as! ReposTableViewCell
        var repo: Repo?
        switch indexPath.section {
        case reposSection.privateSection.rawValue:
            repo = stateController.reposDictionary["private"]?[indexPath.row]
        case reposSection.publicSection.rawValue:
            repo = stateController.reposDictionary["public"]?[indexPath.row]
        default:
            break
        }
        
        cell.fullnameLabel.text = repo?.full_name ?? "repo name"
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return reposSection(rawValue: section)?.title
    }
}

