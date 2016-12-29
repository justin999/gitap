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

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    func pushDetailViewController(inViewController: UIViewController, stateController: StateController) {
        let vc = ReposDetailViewController()
        vc.stateController = stateController
        inViewController.navigationController?.pushViewController(vc, animated: true)
    }
    
    func presentManageIssuesViewController(inViewController: UIViewController) {
        let vc = ManageIssuesViewController()
        vc.stateController = self
        inViewController.present(vc, animated: true, completion: nil)
    }

}
