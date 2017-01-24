//
//  ViewController.swift
//  gitap
//
//  Created by Koichi Sato on 12/24/16.
//  Copyright © 2016 Koichi Sato. All rights reserved.
//

import UIKit
import SafariServices

class FeedsViewController: UIViewController {
    var stateController: StateController?
    @IBOutlet weak var tableView: UITableView!
    
    var tableViewDataSource: FeedsTableViewDataSource?
    var tableViewDelegate:   FeedsTableViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(FeedsTableViewCell.self, forCellReuseIdentifier: feedsCellId)
        if let stateController = self.stateController, let userName = UserDefaults.standard.string(forKey: Constant.userDefaults.githubLoginName) {
            stateController.getIssueEvents(userName: userName) { (isSuccess) in
                
                if isSuccess {
                    self.tableViewDataSource = FeedsTableViewDataSource(tableView: self.tableView, stateController: stateController)
                    self.tableViewDelegate = FeedsTableViewDelegate(tableView: self.tableView, stateController: stateController)
                    self.tableView.reloadData()
                } else {
                    print("something went wrong")
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        stateController?.viewController = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

