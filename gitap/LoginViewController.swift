//
//  LoginViewController.swift
//  gitap
//
//  Created by Koichi Sato on 1/4/17.
//  Copyright © 2017 Koichi Sato. All rights reserved.
//

import UIKit

protocol LoginViewDelegate: class {
    func didTapLoginButton()
}

class LoginViewController: UIViewController {
    weak var delegate: LoginViewDelegate?
    @IBAction func loginButtonTapped() {
        delegate?.didTapLoginButton()
    }
}
