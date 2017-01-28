//
//  Utils.swift
//  gitap
//
//  Created by Koichi Sato on 12/25/16.
//  Copyright © 2016 Koichi Sato. All rights reserved.
//

import UIKit
import SafariServices

class Utils: NSObject {
    class func addRightBarButton(navigationController: UINavigationController, target: Any?) {
        let item = UINavigationItem()
        let plusButton = UIBarButtonItem(barButtonSystemItem: .add, target: target, action: #selector(Utils.addButtonTapped(stateController:)))
        item.rightBarButtonItem = plusButton
        navigationController.navigationBar.items = [item]
    }
    
    class func addButtonTapped(stateController: StateController) {
        let destination = CreateIssuesViewController()
        stateController.present(destination: destination, inViewController: stateController.viewController)
    }
    
    // TODO: タイムゾーンを選べるように
    class func dateFormatter() -> DateFormatter {
        let aDateFormatter = DateFormatter()
        aDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        aDateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        aDateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return aDateFormatter
    }
    
    class func presentAlert(inViewController: UIViewController,title: String, message: String, style: UIAlertControllerStyle, actions: [UIAlertAction]?, completion: (() -> Void)?) {
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: style)
        if let actions = actions {
            for action in actions {
                alert.addAction(action)
            }
        }
        inViewController.present(alert, animated: true, completion: completion)
    }
    
    class func registerCell(_ tableView: UITableView, nibName: String, cellId: String) {
        let nib = UINib(nibName: nibName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
    }
    
    class func showOAuthLoginView(inViewcontroller: UIViewController, delegate: LoginViewDelegate) {
        GitHubAPIManager.sharedInstance.isLoadingOAuthToken = true
        let loginVC = LoginViewController(nibName: "LoginViewController", bundle: nil)
        loginVC.delegate = delegate
        inViewcontroller.present(loginVC, animated: true, completion: nil)
    }

}
