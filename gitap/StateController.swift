//
//  StateController.swift
//  gitap
//
//  Created by Koichi Sato on 12/24/16.
//  Copyright © 2016 Koichi Sato. All rights reserved.
//

import UIKit
import Alamofire
import Photos

class StateController: NSObject {
    var viewController: UIViewController
    var originalViewController: UIViewController?
    var issueEvents: [Event]?
    var repos: [Repo]?
    var selectedRepo: Repo?
    var photos: PHFetchResult<PHAsset>!
    

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    // MARK: - segue
    func push(destination: MasterViewController, inViewController: UIViewController) {
        destination.stateController = self
        inViewController.navigationController?.pushViewController(destination, animated: true)
    }
    
    func present(destination: MasterViewController, inViewController: UIViewController) {
        destination.stateController = self
        originalViewController = self.viewController
        self.viewController = destination
        inViewController.present(destination, animated: true, completion: nil)
    }
    
    func present(destinationNav: UINavigationController, inViewController: UIViewController) {
        guard let rootViewController = destinationNav.viewControllers.first as? MasterViewController else { fatalError("unexpected rootViewController") }
        rootViewController.stateController = self
        originalViewController = self.viewController
        self.viewController = rootViewController
        // This is the different part from present(destination:inViewController)
        // it should present UINavigationController
        inViewController.present(destinationNav, animated: true, completion: nil)
    }
    
    func present(storyBoardName: String, inViewController: UIViewController) {
        let storyBoard = UIStoryboard(name: storyBoardName, bundle: nil)
        guard let vc = storyBoard.instantiateInitialViewController() as? MasterViewController else {
            fatalError("unexpected rootViewController in \(String(describing: self))")
        }
        self.present(destination: vc, inViewController: inViewController)
    }
    
    func dismiss(animated: Bool, completion: (() -> Void)?) {
        if let originalViewController = originalViewController {
            self.viewController = originalViewController
        }
        if let completion = completion { completion() }
        self.viewController.dismiss(animated: animated, completion: completion)
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
