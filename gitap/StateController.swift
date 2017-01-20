//
//  StateController.swift
//  gitap
//
//  Created by Koichi Sato on 12/24/16.
//  Copyright © 2016 Koichi Sato. All rights reserved.
//

import UIKit
import Alamofire

class StateController: NSObject {
    var viewController: UIViewController
    var issues: [Issue]?
    var repos: [Repo]?

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    // segue
    func pushDetailViewController(inViewController: UIViewController, stateController: StateController) {
        let vc = ReposDetailViewController()
        vc.stateController = stateController
        inViewController.navigationController?.pushViewController(vc, animated: true)
    }
    
    func pushIssueDetailViewController(inViewController: UIViewController, stateController: StateController) {
        let vc = IssueDetailViewController()
        vc.stateController = stateController
        inViewController.navigationController?.pushViewController(vc, animated: true)
    }
    
    func presentManageIssuesViewController(inViewController: UIViewController) {
        let vc = CreateIssuesViewController()
        vc.stateController = self
        inViewController.present(vc, animated: true, completion: nil)
    }
    
    // data
    // users
    func fetchAuthenticatedUser(completionHandler: @escaping ((Bool) -> Void)) {
        GitHubAPIManager.sharedInstance.fetch(userRouter.fetchAuthenticatedUser()) { (result: Result<[User]>, nextpage) in
            guard result.error == nil else {
                self.handleLoadIssuesError(result.error!)
                return
            }
            
            guard let fetchedUsers = result.value else {
                print("no user fetched")
                return
            }
            if let user = fetchedUsers.first {
                let userDefault = UserDefaults()
                userDefault.set(user.loginName, forKey: "githubLoginName")
                userDefault.set(user.githubId, forKey: "githubUserId")
                completionHandler(true)
            }
            
        }
    }
    
    // MARK: - issues
    func getIssues(params: [String: Any], completionHandler: @escaping ((Bool) -> Void)) {
        GitHubAPIManager.sharedInstance.fetch(IssueRouter.listIssues(params)) { (result: Result<[Issue]>, nextPage) in
            guard result.error == nil else {
                self.handleLoadIssuesError(result.error!)
                return
            }
            
            guard let fetchedIssues = result.value else {
                print("no issues fetched")
                return
            }
            
            print("fetchedIsssues: \(fetchedIssues)")
            self.issues = fetchedIssues
            completionHandler(true)
            
            
        }
    }
    
    // MARK: - repos
    func getRepos(completionHandler:@escaping ((Bool) -> Void)) {
        GitHubAPIManager.sharedInstance.fetch(RepoRouter.listRepos()) { (result: Result<[Repo]>, nextPage) in
            guard result.error == nil else {
                self.handleLoadIssuesError(result.error!)
                return
            }
            
            guard let fetchedRepos = result.value else {
                print("no repos fetched")
                return
            }
            
            self.repos = fetchedRepos
            completionHandler(true)
        }
    }
    
    // MARK: - feeds
    func listFeeds(completionHandler: ((Bool) -> Void)?) {
        GitHubAPIManager.sharedInstance.fetch(ActivityRouter.listFeeds()) { (result: Result<[Feed]>, nextPage) in
            
            completionHandler!(true)
        }
    }
    
    func handleLoadIssuesError(_ error: Error) {
        print(error)
//        nextPageURLString = nil
//        isLoading = false
//        self.isLoading = false
        switch error {
        case GitHubAPIManagerError.authLost:
//            self.showOAuthLoginView()
            return
        case GitHubAPIManagerError.network(let innerError as NSError):
            // check the domain
            if innerError.domain != NSURLErrorDomain {
                break
            }
            // check the code:
            if innerError.code == NSURLErrorNotConnectedToInternet {
//                showNotConnectedBanner()
                return
            }
        default:
            break
        }
    }
    
    

}
