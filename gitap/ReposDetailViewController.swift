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
//    var segmentedControl: UISegmentedControl?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
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
    
    func addButtonTapped() {
        print("add button tapped")
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
