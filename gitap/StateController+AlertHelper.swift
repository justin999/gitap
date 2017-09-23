//
//  AlertHelper.swift
//  gitap
//
//  Created by Koichi Sato on 1/9/17.
//  Copyright © 2017 Koichi Sato. All rights reserved.
//

import UIKit

extension StateController {
    func presentAlert(title: String, message: String?, style: UIAlertControllerStyle, actions: [UIAlertAction], completion: (() -> Void)?) {
        
        Utils.presentAlert(inViewController: self.viewController, title: title, message: message, style: style, actions: actions, completion: completion)
        }
}
