//
//  UIAlert_extension.swift
//  gitap
//
//  Created by Koichi Sato on 1/30/17.
//  Copyright © 2017 Koichi Sato. All rights reserved.
//

import UIKit

extension UIAlertAction {
    
    class func okAlert() -> UIAlertAction {
        return UIAlertAction(title: "OK", style: .default, handler: nil)
    }

}
