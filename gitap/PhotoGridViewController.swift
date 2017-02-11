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
    var fetchResult: PHFetchResult<PHAsset>!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate var thumbnailSize: CGSize!
    var collectionViewDelegate: PhotosCollectionViewDelegate?
    var collectionViewDataSource: PhotosCollectionViewDataSource?
    
    var uploadButton: UIBarButtonItem?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let stateController = super.stateController {
            collectionViewDataSource = PhotosCollectionViewDataSource(collectionView: collectionView, stateController: stateController)
            collectionViewDataSource?.fetchResult = fetchResult
            collectionViewDelegate = PhotosCollectionViewDelegate(collectionView: collectionView, stateController: stateController)
        }
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let navigationController = self.navigationController {
            uploadButton = UIBarButtonItem(title: "Upload", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.upload(images:)))
            navigationController.topViewController?.navigationItem.rightBarButtonItem = uploadButton
        }
    }
    
    deinit {
//        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc private func upload(images: [Data]) {
        print("upload button tapped")
    }

}
