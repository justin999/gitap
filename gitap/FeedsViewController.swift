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
        self.view.backgroundColor = UIColor.blue
        if let stateController = stateController {
            tableViewDataSource = FeedsTableViewDataSource(tableView: tableView, stateController: stateController)
            tableViewDelegate = FeedsTableViewDelegate(tableView: tableView, stateController: stateController)
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

