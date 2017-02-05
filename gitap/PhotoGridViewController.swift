//
//  PhotoGridViewController.swift
//  gitap
//
//  Created by Koichi Sato on 2017/02/05.
//  Copyright © 2017 Koichi Sato. All rights reserved.
//

import UIKit
import Photos
import PhotosUI

private extension UICollectionView {
    func indexPathsForElements(in rect: CGRect) -> [IndexPath] {
        let allLayoutAttributes = collectionViewLayout.layoutAttributesForElements(in: rect)!
        return allLayoutAttributes.map { $0.indexPath }
    }
}

class PhotoGridViewController: MasterViewController {
    
    var assetCollection: PHAssetCollection!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate var thumbnailSize: CGSize!
    var collectionViewDelegate: PhotosCollectionViewDelegate?
    var collectionViewDataSource: PhotosCollectionViewDataSource?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let stateController = super.stateController {
            collectionViewDataSource = PhotosCollectionViewDataSource(collectionView: collectionView, stateController: stateController)
            collectionViewDelegate = PhotosCollectionViewDelegate(collectionView: collectionView, stateController: stateController)
        }
        
    }
    
    deinit {
//        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
