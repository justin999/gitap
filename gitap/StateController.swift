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

    func pushDetailViewController(inViewController: UIViewController) {
        let vc = ReposDetailViewController()
        inViewController.navigationController?.pushViewController(vc, animated: true)
    }

}
