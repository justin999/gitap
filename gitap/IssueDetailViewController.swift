//
//  IssueDetailViewController.swift
//  gitap
//
//  Created by Koichi Sato on 12/30/16.
//  Copyright © 2016 Koichi Sato. All rights reserved.
//

import UIKit

class IssueDetailViewController: MasterViewController {
    @IBOutlet weak var issueStatusImage: UIImageView!
    
    @IBOutlet weak var issueNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var tableViewDelegate: IssueDetailTableViewDelegate?
    var tableViewDataSource: IssueDetailTableViewDataSource?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let stateController = stateController {
            tableViewDelegate = IssueDetailTableViewDelegate(tableView: tableView, stateController: stateController)
            tableViewDataSource = IssueDetailTableViewDataSource(tableView: tableView, stateController: stateController)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        stateController?.viewController = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
