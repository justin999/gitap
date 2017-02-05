//
//  PhotosTableViewDelegate.swift
//  gitap
//
//  Created by Koichi Sato on 2017/02/04.
//  Copyright © 2017 Koichi Sato. All rights reserved.
//

import UIKit
import Photos

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
        tableView.deselectRow(at: indexPath, animated: false)
        let destination = PhotoGridViewController()
        // TODO: refactor 
        // ここはindexPathをdestinationかPhotoManagerに渡して、そっちに処理を逃したい。
        if indexPath.section == Section.allPhotos.rawValue {
            destination.fetchResult = PhotoManager.shared.allPhotos
        } else {
            let collection: PHCollection
            switch Section(rawValue: indexPath.section)! {
            case .smartAlbums:
                collection = PhotoManager.shared.smartAlbums.object(at: indexPath.row)
            case .userCollections:
                collection = PhotoManager.shared.userCollections.object(at: indexPath.row)
            default: return
            }
            
            // configure the view controller with the asset collection
            guard let assetCollection = collection as? PHAssetCollection
                else { fatalError("expected asset collection") }
            destination.fetchResult = PHAsset.fetchAssets(in: assetCollection, options: nil)
            destination.assetCollection = assetCollection
        }
        self.stateController.push(destination: destination, inViewController: stateController.viewController)
    }
    
}
