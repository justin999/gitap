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
            print("oauth token = ", GitHubAPIManager.shared.OAuthToken)
            guard let userId = UserDefaults.standard.value(forKey: Constant.userDefaults.githubLoginId) as? Int else { return }
            self.stateController.deleteGitHubAuthorization(userId: userId, completionHandler: { (result) in
                
                GitHubAPIManager.shared.clearOAuthToken()
                let okAlert = UIAlertAction(title: "OK", style: .cancel) { okAlert in
                    DispatchQueue.main.async {
                        self.stateController.viewController.performSegue(withIdentifier: String.segue.backToSetupSegue, sender: nil)
                    }
                }
                DispatchQueue.main.async {
                    self.stateController.presentAlert(title: "user info", message: "oauth token deleted", style: .alert, actions: [okAlert], completion: nil)
                }
                
                
                
//                print("result: ", result)
//                switch result {
//                case let .failure(error):
//                    print("error: ", error)
//                case let .success(user):
//                    print("success: ", user)
//                    GitHubAPIManager.shared.clearOAuthToken()
//                    let okAlert = UIAlertAction(title: "OK", style: .cancel) { okAlert in
//                        DispatchQueue.main.async {
//                            self.stateController.viewController.performSegue(withIdentifier: String.segue.backToSetupSegue, sender: nil)
//                        }
//                    }
//                    DispatchQueue.main.async {
//                        self.stateController.presentAlert(title: "user info", message: "oauth token deleted", style: .alert, actions: [okAlert], completion: nil)
//                    }
//                }
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
