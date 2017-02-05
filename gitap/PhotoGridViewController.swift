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
    
    fileprivate var thumbnailSize: CGSize!
    var collectionViewDelegate: PhotosCollectionViewDelegate?
    var collectionViewDataSource: PhotosCollectionViewDataSource?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    deinit {
//        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Determine the size of the thumbnails to request from the PHCachingImageManager
        let scale = UIScreen.main.scale
//        let cellSize = (collectionViewLayout as! UICollectionViewFlowLayout).itemSize
//        thumbnailSize = CGSize(width: cellSize.width * scale, height: cellSize.height * scale)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
