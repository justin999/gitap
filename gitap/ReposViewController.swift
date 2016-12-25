//
//  ReposViewController.swift
//  gitap
//
//  Created by Koichi Sato on 12/24/16.
//  Copyright © 2016 Koichi Sato. All rights reserved.
//

import UIKit

class ReposViewController: UIViewController {
    var stateController: StateController?
    @IBOutlet weak var tableView: UITableView!
    
    var tableViewDataSource: ReposTableViewDataSource?
    var tableViewDelegate:   ReposTableViewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let stateController = stateController {
            tableViewDataSource = ReposTableViewDataSource(tableView: tableView, stateController: stateController)
            tableViewDelegate   = ReposTableViewDelegate(tableView: tableView, stateController: stateController)
        }
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
