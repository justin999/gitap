//
//  SettingsViewController.swift
//  gitap
//
//  Created by Koichi Sato on 12/24/16.
//  Copyright © 2016 Koichi Sato. All rights reserved.
//

import UIKit
import Alamofire

class SettingsViewController: UIViewController {
    var stateController: StateController?
    
    @IBOutlet weak var tableView: UITableView!
    var tableViewDataSource: SettingsTableViewDataSource?
    var tableViewDelegate:   SettingsTableViewDelegate?


    override func viewDidLoad() {
        super.viewDidLoad()
        if let stateController = stateController {
            tableViewDataSource = SettingsTableViewDataSource(tableView: tableView, stateController: stateController)
            tableViewDelegate   = SettingsTableViewDelegate(tableView: tableView, stateController: stateController)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        stateController?.viewController = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == String.segue.backToSetupSegue, let setupVC = segue.destination as? SetupAccountViewController {
            // TODO: LoginViewControllerのボタンの処理がSetupAccountVCで実装されているのが厄介。
            DispatchQueue.main.async {
                setupVC.performSegue(withIdentifier: String.segue.presentLoginSegue, sender: nil)
                setupVC.stateController = self.stateController
            }
            
        }
    }

}
