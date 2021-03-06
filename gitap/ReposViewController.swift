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
    
    override func viewDidAppear(_ animated: Bool) {
        stateController?.viewController = self
        
        if GitHubAPIManager.shared.hasOAuthToken() {
            stateController?.getRepos { success in
                switch success {
                case true:
                    // reloading data should be done in main thread, otherwise the autolayout waring will occur.
                    // ref. http://stackoverflow.com/questions/38983363/this-application-is-modifying-the-autolayout-engine-error-swift-ios
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                case false:
                    print("fetching faield")
                }
            }
            //            GitHubAPIManager.shared.printIssues()
        } else {
//            self.showOAuthLoginView()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "presentEditIssue",
            let destiantion = segue.destination as? UINavigationController,
            let vc = destiantion.topViewController as? CreateIssuesViewController {
            vc.stateController = stateController
        }
    }
}
