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
    var reposDictionary = [String: [Repo]]()
    var privateRepos: [Repo]? {
        didSet {
            if let pr = privateRepos { reposDictionary["private"] = pr }
        }
    }
    var publicRepos: [Repo]? {
        didSet {
            if let pr = publicRepos { reposDictionary["public"] = pr }
        }
    }
    
    var selectedRepo: Repo?
    var photos: PHFetchResult<PHAsset>!
    
    var gitHubClient = GitHubClient()

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    // MARK: - segue
    func push(destination: MasterViewController, inViewController: UIViewController) {
        destination.stateController = self
        inViewController.navigationController?.pushViewController(destination, animated: true)
    }
    
    func pushWebView(destination: UIViewController, inViewController: UIViewController) {
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
    
    func getUploadImageData(image: PHAsset, options: PHImageRequestOptions?, completionHandler: @escaping (Data?, Error?) -> Void) {
        // ref. https://github.com/steve228uk/ImgurKit
        PHImageManager.default().requestImageData(for: image, options: options) { (imageData, dataUTI, orientation, info) in
            if let data = imageData {
                completionHandler(data, nil)
            } else {
                completionHandler(nil, ImgurManagerError.objectSerialization(reason: "some thing went wrong while fetching the data"))
            }
        }
    }
    
    // MARK: - Users
    func fetchAuthenticatedUser(completionHandler: @escaping ((Results<User, GitHubClientError>) -> Void)) {
        let request = GitHubAPI.FetchAuthenticatedUser()
        gitHubClient.send(request: request) { result in
            completionHandler(result)
        }
    }
    
    func deleteGitHubAuthorization(userId: Int, completionHandler: @escaping ((Results<User, GitHubClientError>) -> Void)) {
        let request = GitHubAPI.DeleteAuthorization()
        gitHubClient.send(request: request) { (result) in
            completionHandler(result)
        }
    }
    
    // MARK: - Events
    func getIssueEvents(userName: String, completionHandler: @escaping ((Bool) -> Void)) {
        GitHubAPIManager.shared.fetch(ActivityRouter.listEventsUserReceived(userName)) { (result: Result<[Event]>, nextPage) in
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
    
    // MARK: - Issues
    func createIssue(params: [String: Any?], completionHandler: ((Results<Issue, GitHubClientError>) -> Void)?) {
        let request = GitHubAPI.CreateIssue(params: params)
        gitHubClient.send(request: request) { result in
            guard let handler = completionHandler else {
                return
            }
            handler(result)
        }
    }
    
    // MARK: - Repos
    func getRepos(completionHandler:@escaping ((Bool) -> Void)) {
        let request = GitHubAPI.ListUserRepositories()
        gitHubClient.send(request: request) { result in
            switch result {
            case let .success(response):
                let fetchedRepos = response.items
                self.privateRepos = fetchedRepos.filter { $0.isPrivate == true }
                self.publicRepos  = fetchedRepos.filter { $0.isPrivate == false }
                self.setRepoInfoIntoUserDefaults()
                completionHandler(true)
            case let .failure(error):
                self.handleLoadIssuesError(error)
                completionHandler(false)
                print(error)
            }
        }
    }
    
    func setRepoInfoIntoUserDefaults() {
        let privateRepoNames = self.privateRepos?.map({ (repo) -> String in
            repo.full_name
        })
        print("private repo names: \(String(describing:privateRepoNames))")
        let publicRepoNames = self.publicRepos?.map({ (repo) -> String in
            repo.full_name
        })
        Utils.setDefaultsValue(value: privateRepoNames, key: "privateRepoNames")
        Utils.setDefaultsValue(value: publicRepoNames, key: "publicRepoNames")
    }
    
    // MARK: - feeds
    func listFeeds(completionHandler: ((Bool) -> Void)?) {
        GitHubAPIManager.shared.fetch(ActivityRouter.listFeeds()) { (result: Result<[Feed]>, nextPage) in
            
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
