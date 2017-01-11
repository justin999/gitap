//
//  CreateItemViewController.swift
//  gitap
//
//  Created by Koichi Sato on 12/26/16.
//  Copyright © 2016 Koichi Sato. All rights reserved.
//
//  aws s3: https://github.com/aws/aws-sdk-ios
//  sample: https://github.com/awslabs/aws-sdk-ios-samples/tree/master/S3TransferManager-Sample/Swift/

import UIKit

class CreateIssuesViewController: UIViewController {
    var stateController: StateController?
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    var tableViewDelegate:   EditIssuesTableViewDelegate?
    var tableViewDataSource: EditIssuesTableViewDataSource?

    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: table view height should be changed dynamically due to change of cells and headers height
//        if let stateController = stateController {
//            tableViewDelegate = EditIssuesTableViewDelegate(tableView: self.tableView, stateController: stateController)
//            tableViewDataSource = EditIssuesTableViewDataSource(tableView: self.tableView, stateController: stateController)
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissView(_ sender: Any) {
        print("sender: \(sender)")
        self.dismiss(animated: true) {
            print("view is dismissed")
        }
    }

    @IBAction func doneButtonTapped(_ sender: Any) {
        print("done button tapped")
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
