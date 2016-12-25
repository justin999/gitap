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
}
