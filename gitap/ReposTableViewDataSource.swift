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
    case publicSection
    case privateSection
    
    static let count = 2
}

class ReposTableViewDataSource: NSObject {
    var stateController: StateController
    
    let reposSectionTitles = ["private", "public"]
    
    init(tableView: UITableView, stateController: StateController) {
        self.stateController = stateController
        super.init()
        tableView.dataSource = self
        Utils.registerCell(tableView, nibName: String(describing: ReposTableViewCell.self), cellId: reposCellId)
    }
}

extension ReposTableViewDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return reposSectionTitles.count
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
        cell.fullnameLabel.text = stateController.repos?[indexPath.row].full_name
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return reposSectionTitles[section]
//        return "public" //private, private members, public, public members, forked
    }
}

