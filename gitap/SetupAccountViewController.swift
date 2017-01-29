//
//  SetupAccountViewController.swift
//  gitap
//
//  Created by Koichi Sato on 1/23/17.
//  Copyright © 2017 Koichi Sato. All rights reserved.
//

import UIKit
import SafariServices

class SetupAccountViewController: MasterViewController, LoginViewDelegate, SFSafariViewControllerDelegate {
    var safariViewController: SFSafariViewController?
    var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    // MARK: private
    func configureViews() {
        stateController?.fetchAuthenticatedUser() { result in
            if result.isFailure {
                // loginviewへ
                let okAlert = UIAlertAction(title: "OK", style: .default) { okAlert in
                    Utils.showOAuthLoginView(inViewcontroller: self, delegate: self)
                }
                Utils.presentAlert(inViewController: self, title: "Please Login to Github", message: "Please login to github account to use this application", style: .alert, actions: [okAlert], completion: nil)
                
            } else if result.isSuccess {
                
                self.user = result.value
                let loginName = self.user?.loginName
                UserDefaults.standard.set(loginName, forKey: Constant.userDefaults.githubLoginName)
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let tabBarController = storyboard.instantiateInitialViewController() as? UITabBarController,
                    let navigationController = tabBarController.viewControllers?.first as? UINavigationController {
                    if let feedsViewController = navigationController.viewControllers.first as? FeedsViewController {
                        feedsViewController.stateController = self.stateController
                        feedsViewController.stateController?.viewController = feedsViewController
                        self.addRightBarButton(navigationController: navigationController)
                        
                    }
                    if let navigationController = tabBarController.viewControllers?[1] as? UINavigationController,
                        let reposViewController = navigationController.viewControllers.first as? ReposViewController {
                        reposViewController.stateController = self.stateController
                        self.addRightBarButton(navigationController: navigationController)
                    }
                    
                    if let navigationController = tabBarController.viewControllers?[2] as? UINavigationController,
                        let settingsViewController = navigationController.viewControllers.first as? SettingsViewController {
                        settingsViewController.stateController = self.stateController
                        self.addRightBarButton(navigationController: navigationController)
                    }
                    
                    self.present(tabBarController, animated: true, completion: nil)
                }
                
            }
            
        }
    }
    
    func addRightBarButton(navigationController: UINavigationController) {
        let item = UINavigationItem()
        let plusButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        item.rightBarButtonItem = plusButton
        navigationController.navigationBar.items = [item]
    }
    
    func addButtonTapped() {
        if let stateController = stateController {
            Utils.addButtonTapped(stateController: stateController)
        }
    }
    
    
    // MARK: - Delegate
    func didTapLoginButton() {
        self.dismiss(animated: false) {
            guard let authURL = GitHubAPIManager.sharedInstance.URLToStartOAuth2Login() else {
                let error = GitHubAPIManagerError.authCouldNot(reason: kMessageFailToObtainToken)
                GitHubAPIManager.sharedInstance.OAuthTokenCompletionHandler?(error)
                return
            }
            self.safariViewController = SFSafariViewController(url: authURL)
            self.safariViewController?.delegate = self
            if let sfViewController = self.safariViewController {
                GitHubAPIManager.sharedInstance.OAuthTokenCompletionHandler = { error in
                    // ログイン成功したら自動的にfeedviewcontrollerへ
                    // 失敗したらもう一度oauth出す
                    guard error == nil else {
                        print(error!)
                        return
                    }
                    
                    if let _ = self.safariViewController {
                        self.dismiss(animated: false, completion: nil)
                        self.configureViews()
                    }
                }
                self.present(sfViewController, animated: true, completion: nil)
            } else {
                print("there's no safariViewController: this shouldn't be done")
            }
        }
        
    }
    
    // MARK: - SFSafariViewControllerDelegate
    // make valid after creating GitHubRouter
    //    func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad
    //        didLoadSuccessfully: Bool) {
    //        // Detect not being able to load the OAuth URL
    //        if (!didLoadSuccessfully) {
    //            controller.dismiss(animated: true, completion: nil)
    //            GitHubAPIManager.sharedInstance.isAPIOnline { isOnline in
    //                if !isOnline {
    //                    print("error: api offline")
    //                    let innerError = NSError(domain: NSURLErrorDomain,
    //                                             code: NSURLErrorNotConnectedToInternet,
    //                                             userInfo: [NSLocalizedDescriptionKey:
    //                                                "No Internet Connection or GitHub is Offline",
    //                                                        NSLocalizedRecoverySuggestionErrorKey: "Please retry your request"])
    //                    let error = GitHubAPIManagerError.network(error: innerError)
    //                    GitHubAPIManager.sharedInstance.OAuthTokenCompletionHandler?(error)
    //                }
    //            }
    //        }
    //    }

}
