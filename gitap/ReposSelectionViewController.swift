//
//  ReposSelectionViewController.swift
//  gitap
//
//  Created by Koichi Sato on 1/27/17.
//  Copyright © 2017 Koichi Sato. All rights reserved.
//

import UIKit

class ReposSelectionViewController: MasterViewController {
    
    var tableViewDelegate: ReposTableViewDelegate?
    var tableViewDataSource: ReposTableViewDataSource?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var selectionBar: UINavigationBar!
    @IBOutlet weak var closeButton: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }

    func configureView() {
        if let stateController = super.stateController {
            stateController.getRepos { isSuccess in
                if isSuccess {
                    self.tableViewDelegate = ReposTableViewDelegate(tableView: self.tableView, stateController: stateController)
                    self.tableViewDataSource = ReposTableViewDataSource(tableView: self.tableView, stateController: stateController)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
