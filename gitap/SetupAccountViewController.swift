//
//  SetupAccountViewController.swift
//  gitap
//
//  Created by Koichi Sato on 1/23/17.
//  Copyright © 2017 Koichi Sato. All rights reserved.
//

import UIKit
import SafariServices

class SetupAccountViewController: UIViewController, LoginViewDelegate, SFSafariViewControllerDelegate {
    var stateController: StateController?
    var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        stateController?.fetchAuthenticatedUser() { result in
            if result.isFailure {
                // loginviewへ
                let okAlert = UIAlertAction(title: "OK", style: .default) { okAlert in
                    Utils.showOAuthLoginView(inViewcontroller: self, delegate: self)
                }
                Utils.presentAlert(inViewController: self, title: "Please Login to Github", message: "Please login to github account to use this application", style: .alert, actions: [okAlert], completion: nil)
                
            } else if result.isSuccess {
                
                self.user = result.value
                
                // TODO:例の3つのtabviewcontrollerを出す
                //        if let tabBarController = window?.rootViewController as? UITabBarController,
                //            let navigationController = tabBarController.viewControllers?.first as? UINavigationController {
                //            if let feedsViewController = navigationController.viewControllers.first as? FeedsViewController {
                //                stateController = StateController(viewController: feedsViewController)
                //                feedsViewController.stateController = stateController
                //                stateController?.viewController = feedsViewController
                //                addRightBarButton(navigationController: navigationController)
                //
                //            }
                //            if let navigationController = tabBarController.viewControllers?[1] as? UINavigationController,
                //                let reposViewController = navigationController.viewControllers.first as? ReposViewController {
                //                reposViewController.stateController = stateController
                //                addRightBarButton(navigationController: navigationController)
                //            }
                //
                //            if let navigationController = tabBarController.viewControllers?[2] as? UINavigationController,
                //                let settingsViewController = navigationController.viewControllers.first as? SettingsViewController {
                //                settingsViewController.stateController = stateController
                //                addRightBarButton(navigationController: navigationController)
                //            }
                //        }
                
            }
            
        }
        
    }

    override func viewDidAppear(_ animated: Bool) {

    }
    
    func didTapLoginButton() {
        Utils.loginAction(viewController: self, sfDelegate: self)
        
    }
}
