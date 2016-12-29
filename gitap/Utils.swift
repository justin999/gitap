//
//  Utils.swift
//  gitap
//
//  Created by Koichi Sato on 12/25/16.
//  Copyright © 2016 Koichi Sato. All rights reserved.
//

import UIKit

class Utils: NSObject {
    
    class func getViewFromNib(_ name: String) -> UIView {
        let nib = UINib(nibName: name, bundle: nil)
        let views = nib.instantiate(withOwner: self, options: nil)
        return views[0] as! UIView
    }
    
    class func addRightBarButton(navigationController: UINavigationController, target: Any?) {
        let item = UINavigationItem()
        let plusButton = UIBarButtonItem(barButtonSystemItem: .add, target: target, action: #selector(Utils.addButtonTapped))
        item.rightBarButtonItem = plusButton
        navigationController.navigationBar.items = [item]
    }
    
    class func addButtonTapped(stateController: StateController) {
        print("add button tapped")
        stateController.presentManageIssuesViewController(inViewController: stateController.viewController)
        
    }
}
