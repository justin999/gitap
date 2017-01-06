//
//  ViewController.swift
//  gitap
//
//  Created by Koichi Sato on 12/24/16.
//  Copyright © 2016 Koichi Sato. All rights reserved.
//

import UIKit
import SafariServices

class FeedsViewController: UIViewController, LoginViewDelegate, SFSafariViewControllerDelegate {
    var stateController: StateController?
    @IBOutlet weak var tableView: UITableView!
    
    var tableViewDataSource: FeedsTableViewDataSource?
    var tableViewDelegate:   FeedsTableViewDelegate?
    
    // tmp: 
    var safariViewController: SFSafariViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(FeedsTableViewCell.self, forCellReuseIdentifier: feedsCellId)
        self.view.backgroundColor = UIColor.blue
        if let stateController = stateController {
            tableViewDataSource = FeedsTableViewDataSource(tableView: tableView, stateController: stateController)
            tableViewDelegate = FeedsTableViewDelegate(tableView: tableView, stateController: stateController)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        stateController?.viewController = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        GitHubAPIManager.sharedInstance.OAuthTokenCompletionHandler = { error in
            guard error == nil else {
                print(error!)
                return
            }
            
            if let _ = self.safariViewController {
                self.dismiss(animated: false, completion: nil)
            }
        }
        
        if GitHubAPIManager.sharedInstance.hasOAuthToken() {
            stateController?.getIssues { success in
                self.tableView.reloadData()
            }
//            GitHubAPIManager.sharedInstance.printIssues()
        } else {
            self.showOAuthLoginView()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // tmp
    func showOAuthLoginView() {
        GitHubAPIManager.sharedInstance.isLoadingOAuthToken = true
        let loginVC = LoginViewController(nibName: "LoginViewController", bundle: nil)
        loginVC.delegate = self
        self.present(loginVC, animated: true, completion: nil)
    }

    // delegate
    func didTapLoginButton() {
        print("button tapped")
        self.dismiss(animated: false) {
            guard let authURL = GitHubAPIManager.sharedInstance.URLToStartOAuth2Login() else {
                let error = GitHubAPIManagerError.authCouldNot(reason: kMessageFailToObtainToken)
                GitHubAPIManager.sharedInstance.OAuthTokenCompletionHandler?(error)
                return
            }
            self.safariViewController = SFSafariViewController(url: authURL)
            self.safariViewController?.delegate = self
            guard let webViewController = self.safariViewController else {
                return
            }
            self.present(webViewController, animated: true, completion: nil)
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

