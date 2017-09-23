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
    
    class func presentAlert(inViewController: UIViewController,title: String, message: String?, style: UIAlertControllerStyle, actions: [UIAlertAction]?, completion: (() -> Void)?) {
        // You should call your UIAlertController on the main thread because you're dealing with the ui.
        // ref. http://stackoverflow.com/questions/39559751/uikeyboardtaskqueue-may-only-be-called-from-the-main-thread
        DispatchQueue.main.async {
            let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: style)
            if let actions = actions {
                for action in actions {
                    alert.addAction(action)
                }
            }
            inViewController.present(alert, animated: true, completion: completion)
        }
    }
    
    class func registerCell(_ tableView: UITableView, nibName: String, cellId: String) {
        let nib = UINib(nibName: nibName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
    }
    
    class func registerCCell(_ collectionView: UICollectionView, nibName: String, cellId: String) {
        let nib = UINib(nibName: nibName, bundle: nil)
//        collectionView.register(nib, forCellReuseIdentifier: cellId)
        collectionView.register(nib, forCellWithReuseIdentifier: cellId)
    }
    
    class func showOAuthLoginView(inViewcontroller: UIViewController, delegate: LoginViewDelegate) {
        GitHubAPIManager.sharedInstance.isLoadingOAuthToken = true
        let loginVC = LoginViewController(nibName: "LoginViewController", bundle: nil)
        loginVC.delegate = delegate
        inViewcontroller.present(loginVC, animated: true, completion: nil)
    }
    
    class func showErrorAlert(error: Error, in inViewController: UIViewController, title: String = "", message: String, afterAction: @escaping () -> Void) {
        Utils.presentAlert(inViewController: inViewController, title: title, message: error.localizedDescription, style: .alert, actions: [UIAlertAction.okAlert()], completion: nil)
        afterAction()
    }
    
    class func getValue<T:Any>(from dictionary:[String: Any], with key: String) throws -> T {
        guard let value = dictionary[key] as? T else {
            throw JSONDecodeError.missingValue(key: key, actualValue: dictionary[key])
        }
        return value
    }

}
