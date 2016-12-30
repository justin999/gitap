//
//  ReposDetailViewController.swift
//  gitap
//
//  Created by Koichi Sato on 12/26/16.
//  Copyright © 2016 Koichi Sato. All rights reserved.
//

import UIKit

class ReposDetailViewController: UIViewController {
    var stateController: StateController?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var addIssueButton: UIButton!
    
    var tableViewDelegate: IssuesTableViewDelegate?
    var tableViewDataSource: IssuesTableViewDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        if let stateController = stateController {
            tableViewDelegate = IssuesTableViewDelegate(tableView: tableView, stateController: stateController)
            tableViewDataSource = IssuesTableViewDataSource(tableView: tableView, stateController: stateController)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        stateController?.viewController = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func configureView() {
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(ReposDetailViewController.segmentValueChanged(segCon:)), for: .valueChanged)
        navigationController?.title = "Repo Name"
    }
    
    func segmentValueChanged(segCon:UISegmentedControl) {
        switch segCon.selectedSegmentIndex {
        case 0:
            print("Issues selected")
        case 1:
            print("Pull Requests selected")
        default:
            print("came to default")
        }
    }

    @IBAction func addIssueButtonTapped(_ sender: Any) {
        if let stateController = stateController {
            Utils.addButtonTapped(stateController: stateController)
        }
        
    }
    
}
