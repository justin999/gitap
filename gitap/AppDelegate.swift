//
//  AppDelegate.swift
//  gitap
//
//  Created by Koichi Sato on 12/24/16.
//  Copyright © 2016 Koichi Sato. All rights reserved.
//

import UIKit
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var stateController: StateController?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        // TODO: feedsVCをロードする前にログインしているかどうかをチェックしたい。
        GitHubAPIManager.sharedInstance.fetch(userRouter.fetchAuthenticatedUser()) { (result: Result<[User]>, nextpage) in
            guard result.error == nil else {
                // TODO: ここで何かセねば
//                self.handleLoadIssuesError(result.error!)
                return
            }
            
            if let fetchedUsers = result.value, let user = fetchedUsers.first {
                UserDefaults.standard.set(user.loginName, forKey: Constant.userDefaults.githubLoginName)
            }
            
        }

        if let tabBarController = window?.rootViewController as? UITabBarController,
            let navigationController = tabBarController.viewControllers?.first as? UINavigationController {
            if let feedsViewController = navigationController.viewControllers.first as? FeedsViewController {
                stateController = StateController(viewController: feedsViewController)
                feedsViewController.stateController = stateController
                stateController?.viewController = feedsViewController
                addRightBarButton(navigationController: navigationController)
                
            }
            if let navigationController = tabBarController.viewControllers?[1] as? UINavigationController,
                let reposViewController = navigationController.viewControllers.first as? ReposViewController {
                reposViewController.stateController = stateController
                addRightBarButton(navigationController: navigationController)
            }
            
            if let navigationController = tabBarController.viewControllers?[2] as? UINavigationController,
                let settingsViewController = navigationController.viewControllers.first as? SettingsViewController {
                settingsViewController.stateController = stateController
                addRightBarButton(navigationController: navigationController)
            }
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        GitHubAPIManager.sharedInstance.processOAuthStep1Response(url)
        return true
    }

    //MARK: private
    func addRightBarButton(navigationController: UINavigationController) {
        let item = UINavigationItem()
        let plusButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        item.rightBarButtonItem = plusButton
        navigationController.navigationBar.items = [item]
    }
    
    func addButtonTapped() {
        stateController?.presentManageIssuesViewController(inViewController: (stateController?.viewController)!)
        
    }
    
}

