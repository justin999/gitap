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

protocol PhotoGridViewControllerDelegate {
    func photoGridViewControllerDismissed(_ gridViewController: PhotoGridViewController, didDismissed imageIndexPath: IndexPath)
}

class PhotoGridViewController: MasterViewController, PhotosCollectionViewUploadDelegate {
    
    var assetCollection: PHAssetCollection!
    var fetchResult: PHFetchResult<PHAsset>!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate var thumbnailSize: CGSize!
    var collectionViewDelegate: PhotosCollectionViewDelegate?
    var collectionViewDataSource: PhotosCollectionViewDataSource?
    var photoGridViewControllerDelegate: PhotoGridViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let stateController = super.stateController {
            collectionViewDataSource = PhotosCollectionViewDataSource(collectionView: collectionView, stateController: stateController)
            collectionViewDataSource?.fetchResult = fetchResult
            collectionViewDelegate = PhotosCollectionViewDelegate(collectionView: collectionView, stateController: stateController)
            collectionViewDelegate?.photosCollectionViewUploadDelegate = self
        }
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let navigationController = self.navigationController {
            let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: nil)
            navigationController.topViewController?.navigationItem.leftBarButtonItem = cancelButton
            cancelButton.action = #selector(self.cancelButtonTapped(_:))
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let sectionNum = self.collectionView.numberOfSections
        let items = self.collectionView.numberOfItems(inSection: sectionNum - 1)
        if items == 0 { return }
        let indexPath: IndexPath = IndexPath(item: items - 1, section: sectionNum - 1)
        
        collectionView.scrollToItem(at: indexPath, at: .bottom, animated: false)
    }
    
    deinit {
//        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - PhotosCollectionViewUploadDelegate
    func uploadActionSelected(_ collectionView: UICollectionView, didSelected indexPath: IndexPath) {
        print("\(#file): \(#function): delegate method called")
        self.dismiss(animated: true) {
            self.photoGridViewControllerDelegate?.photoGridViewControllerDismissed(self, didDismissed: indexPath)
        }
    }
    
}
