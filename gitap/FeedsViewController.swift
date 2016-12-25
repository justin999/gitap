//
//  ViewController.swift
//  gitap
//
//  Created by Koichi Sato on 12/24/16.
//  Copyright © 2016 Koichi Sato. All rights reserved.
//

import UIKit

class FeedsViewController: UIViewController {
    var stateController: StateController?
    @IBOutlet weak var tableView: UITableView!
    
    var tableViewDataSource: FeedsTableViewDataSource?
    var tableViewDelegate:   FeedsTableViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blue
        if let stateController = stateController {
            tableViewDataSource = FeedsTableViewDataSource(tableView: tableView, stateController: stateController)
            tableViewDelegate = FeedsTableViewDelegate(tableView: tableView, stateController: stateController)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

