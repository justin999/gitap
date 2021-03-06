//
//  SettingsTableViewDelegate.swift
//  gitap
//
//  Created by Koichi Sato on 12/25/16.
//  Copyright © 2016 Koichi Sato. All rights reserved.
//

import UIKit

class SettingsTableViewDelegate: NSObject {
    let stateController: StateController
    
    init(tableView: UITableView, stateController: StateController) {
        self.stateController = stateController
        super.init()
        tableView.delegate = self
    }

}

extension SettingsTableViewDelegate: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if indexPath.section == 0 && indexPath.row == 2 {
            print("clearing oauth token")
            self.stateController.deleteGitHubAuthorization(completionHandler: { (result) in
                switch result {
                case .failure(_):
                    DispatchQueue.main.async {
                        self.stateController.presentAlert(title: "", message: "Failed to Logout from Gitap", style: .alert, actions: [UIAlertAction.okAlert()], completion: nil)
                    }
                case .success(_):
                    GitHubAPIManager.shared.clearOAuthToken()
                    let okAlert = UIAlertAction(title: "OK", style: .cancel) { okAlert in
                        DispatchQueue.main.async {
                            self.stateController.viewController.performSegue(withIdentifier: String.segue.backToSetupSegue, sender: nil)
                        }
                    }
                    DispatchQueue.main.async {
                        self.stateController.presentAlert(title: "", message: "Successfully Logout from Gitap", style: .alert, actions: [okAlert], completion: nil)
                    }
                }
            })
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    
}
