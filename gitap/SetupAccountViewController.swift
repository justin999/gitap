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
            switch result {
            case let .success(user):
                self.user = user
                let loginName = self.user?.loginName
                UserDefaults.standard.set(loginName, forKey: Constant.userDefaults.githubLoginName)
                
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "showMainTabBarConrollerSegue", sender: nil)
                }
            case let .failure(error):
                print("error: \(error)")
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "presentLoginViewSegue", sender: nil)
                }
            }
        }
    }
    
    // MARK: - Delegate
    func didTapLoginButton() {
        self.dismiss(animated: false) {
            guard let authURL = GitHubAPIManager.shared.URLToStartOAuth2Login() else {
                let error = GitHubAPIManagerError.authCouldNot(reason: kMessageFailToObtainToken)
                GitHubAPIManager.shared.OAuthTokenCompletionHandler?(error)
                return
            }
            self.safariViewController = SFSafariViewController(url: authURL)
            self.safariViewController?.delegate = self
            
            guard let sfViewController = self.safariViewController else { return }
            GitHubAPIManager.shared.OAuthTokenCompletionHandler = { error in
                guard error == nil else {
                    print(error!)
                    return
                }
                
                if let _ = self.safariViewController {
                    DispatchQueue.main.async {
                        self.dismiss(animated: false, completion: nil)
                        self.configureViews()
                    }
                }
            }
            self.present(sfViewController, animated: true, completion: nil)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "presentLoginViewSegue", let destination = segue.destination as? LoginViewController {
            destination.delegate = self
        }
        
        if segue.identifier == "showMainTabBarConrollerSegue", let tabBarController = segue.destination as? UITabBarController {
            
            if let navigationController = tabBarController.viewControllers?[0] as? UINavigationController,
                let reposViewController = navigationController.viewControllers.first as? ReposViewController {
                reposViewController.stateController = self.stateController
            }
            
            if let navigationController = tabBarController.viewControllers?[1] as? UINavigationController,
                let settingsViewController = navigationController.viewControllers.first as? SettingsViewController {
                settingsViewController.stateController = self.stateController
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
    //            GitHubAPIManager.shared.isAPIOnline { isOnline in
    //                if !isOnline {
    //                    print("error: api offline")
    //                    let innerError = NSError(domain: NSURLErrorDomain,
    //                                             code: NSURLErrorNotConnectedToInternet,
    //                                             userInfo: [NSLocalizedDescriptionKey:
    //                                                "No Internet Connection or GitHub is Offline",
    //                                                        NSLocalizedRecoverySuggestionErrorKey: "Please retry your request"])
    //                    let error = GitHubAPIManagerError.network(error: innerError)
    //                    GitHubAPIManager.shared.OAuthTokenCompletionHandler?(error)
    //                }
    //            }
    //        }
    //    }

}
