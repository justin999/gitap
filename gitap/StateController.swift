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
    var issueEvents: [Event]?
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
    
    func presentSetupViewController(inViewController: UIViewController) {
        let storyboard = UIStoryboard(name: "SetupAccount", bundle: nil)
        if let setupVC = storyboard.instantiateInitialViewController() as? SetupAccountViewController {
            setupVC.stateController = self
            inViewController.present(setupVC, animated: true, completion: nil)
        } else {
            print("something went wrong")
        }
    }
    
    // data
    // users
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
//            TODO: fetchedEventsの中からさらにissueeventのものに絞る type: IssueCommentEvent, IssuesEvent
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
