//
//  StateController.swift
//  gitap
//
//  Created by Koichi Sato on 12/24/16.
//  Copyright © 2016 Koichi Sato. All rights reserved.
//

import UIKit

class StateController: NSObject {
    var viewController: UIViewController
    var issues: [Issue]?

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
        let vc = ManageIssuesViewController()
        vc.stateController = self
        inViewController.present(vc, animated: true, completion: nil)
    }
    
    // data
    func getIssues(completionHandler:@escaping ((Bool) -> Void)) {
        GitHubAPIManager.sharedInstance.fetchIssues(IssueRouter.listIssues()) { (result, nextPage) in
            guard result.error == nil else {
                self.handleLoadIssuesError(result.error!)
                return
            }
            
            guard let fetchedIssues = result.value else {
                print("no gists fetched")
                return
            }
            
            print("fetchedIsssues: \(fetchedIssues)")
            self.issues = fetchedIssues
            completionHandler(true)
            
            
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
