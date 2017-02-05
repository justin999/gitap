//
//  PhotoSectionsViewController.swift
//  gitap
//
//  Created by Koichi Sato on 2017/02/04.
//  Copyright © 2017 Koichi Sato. All rights reserved.
//

import UIKit
import Photos

class PhotoSectionsViewController: MasterViewController {
    
    var photosTableViewDataSource: PhotosTableViewDataSource?
    var photosTableViewDelegate: PhotosTableViewDelegate?

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let stateController = super.stateController {
            photosTableViewDataSource = PhotosTableViewDataSource(tableView: tableView, stateController: stateController)
            photosTableViewDelegate = PhotosTableViewDelegate(tableView: tableView, stateController: stateController)
        }
        
        if let navigationController = self.navigationController {
            let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.done, target: self, action: nil)
            navigationController.topViewController?.navigationItem.rightBarButtonItem = cancelButton
            cancelButton.action = #selector(self.cancelButtonTapped(_:))
        }
    }

    func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
