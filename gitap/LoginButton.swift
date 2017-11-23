//
//  LoginButton.swift
//  gitap
//
//  Created by Koichi Sato on 2017/11/23.
//  Copyright © 2017 Koichi Sato. All rights reserved.
//

import Foundation
import UIKit

class LoginButton: UIButton {
    override func layoutSubviews() {
        self.layer.cornerRadius = 10
        super.layoutSubviews()
    }
}
