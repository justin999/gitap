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
    var originalViewController: UIViewController?
    var issueEvents: [Event]?
    var repos: [Repo]?
    var selectedRepo: Repo?

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    // MARK: - segue
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
    
    func showRepoLists() {
        
    }
    
    func presentManageIssuesViewController(inViewController: UIViewController) {
        let vc = CreateIssuesViewController()
        vc.stateController = self
        self.viewController = vc
        inViewController.present(vc, animated: true, completion: nil)
    }
    
    func presentSetupViewController(inViewController: UIViewController) {
        let storyboard = UIStoryboard(name: "SetupAccount", bundle: nil)
        if let setupVC = storyboard.instantiateInitialViewController() as? SetupAccountViewController {
            setupVC.stateController = self
            inViewController.present(setupVC, animated: true, completion: nil)
        } else {
            print("something went wrong")
        }
    }
    
    func present(destination: MasterViewController, inViewController: UIViewController) {
        destination.stateController = self
        originalViewController = self.viewController
        self.viewController = destination
        inViewController.present(destination, animated: true, completion: nil)
    }
    
    func dismiss(animated: Bool, completion: (() -> Void)?) {
        if let originalViewController = originalViewController {
            self.viewController = originalViewController
        }
        self.viewController.dismiss(animated: animated, completion: completion)
    }
    
    func push(destination: MasterViewController, inViewController: UIViewController, stateController: StateController) {
        let vc = MasterViewController()
        vc.stateController = self
        inViewController.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - data
    func selectRepo(repo: Repo) {
        selectedRepo = repo
    }
    
    // MARK: - users
    func fetchAuthenticatedUser(completionHandler: @escaping ((Result<User>) -> Void)) {
        GitHubAPIManager.sharedInstance.fetch(userRouter.fetchAuthenticatedUser()) { (result: Result<[User]>, nextpage) in
            guard result.error == nil else {
                self.handleLoadIssuesError(result.error!)
                completionHandler(.failure(result.error!))
                return
            }
            
            if let fetchedUsers = result.value, let user = fetchedUsers.first {
                completionHandler(.success(user))
            }
            
        }
    }
    
    // MARK: - Events
    func getIssueEvents(userName: String, completionHandler: @escaping ((Bool) -> Void)) {
        GitHubAPIManager.sharedInstance.fetch(ActivityRouter.listEventsUserReceived(userName)) { (result: Result<[Event]>, nextPage) in
            print("events: \(result)")
            
            guard result.error == nil else {
                self.handleLoadIssuesError(result.error!)
                return
            }
            
            guard let fetchedEvents = result.value else {
                print("no issues fetched")
                return
            }
            
            print("fetchedIsssues: \(fetchedEvents)")
            // fetchedEventsの中からさらにissueeventのものに絞る type: IssueCommentEvent, IssuesEvent
            var eventsArray = [Event]()
            fetchedEvents.forEach { event in
                if event.type == "IssueCommentEvent" || event.type == "IssuesEvent" {
                    eventsArray.append(event)
                }
            }
            self.issueEvents = eventsArray
            completionHandler(true)
        }
    }
    
    // MARK: - repos
    func createIssue(params: [String: Any?], completionHandler: ((Result<Issue>) -> Void)?) {
        GitHubAPIManager.sharedInstance.fetch(IssueRouter.createIssue(params)) { (result: Result<[Issue]>, nextPage) in
            // TODO: いったん簡単なissueを作ってみる
            guard result.error == nil else {
                self.handleLoadIssuesError(result.error!)
                if let handler = completionHandler {
                    handler(.failure(result.error!))
                }
                return
            }
            
            guard let createdIssue = result.value?.first else {
                print("No Issue Created")
                if let handler = completionHandler {
                    handler(.failure(result.error!))
                }
                return
            }
            
            print("Created Issue: \(createdIssue)")
            if let handler = completionHandler {
                handler(.success(createdIssue))
            }
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
