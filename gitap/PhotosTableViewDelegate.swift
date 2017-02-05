//
//  PhotosTableViewDelegate.swift
//  gitap
//
//  Created by Koichi Sato on 2017/02/04.
//  Copyright © 2017 Koichi Sato. All rights reserved.
//

import UIKit

class PhotosTableViewDelegate: NSObject {
    let stateController: StateController
    
    init(tableView: UITableView, stateController: StateController) {
        self.stateController = stateController
        super.init()
        tableView.delegate = self
    }
}

extension PhotosTableViewDelegate: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destination = PhotoGridViewController()
        self.stateController.push(destination: destination, inViewController: stateController.viewController)
    }
    
}
