//
//  SettingsViewController.swift
//  gitap
//
//  Created by Koichi Sato on 12/24/16.
//  Copyright © 2016 Koichi Sato. All rights reserved.
//

import UIKit

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
        
        // TODO: この処理は最終的にはアプリがフォアグラウンドに入ってきたときにやる
        self.stateController?.fetchAuthenticatedUser { (success) in
            print("success???: \(success)")
            // if successだったら何もしない
            // else ログインアラートを出す
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
