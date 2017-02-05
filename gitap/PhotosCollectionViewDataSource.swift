//
//  PhotosCollectionViewDataSource.swift
//  gitap
//
//  Created by Koichi Sato on 2017/02/05.
//  Copyright © 2017 Koichi Sato. All rights reserved.
//

import UIKit
import Photos

class PhotosCollectionViewDataSource: NSObject {
    
    var stateController: StateController
    
    var fetchResult: PHFetchResult<PHAsset>!
    
    
    fileprivate var thumbnailSize: CGSize!
    fileprivate let imageManager = PHCachingImageManager()
    
    init(collectionView: UICollectionView, stateController: StateController) {
        self.stateController = stateController
        super.init()
        collectionView.dataSource = self
        
        
        thumbnailSize = CGSize(width: 50, height: 50)
        
        fetchResult = PhotoManager.shared.allPhotos
    }
    
}

extension PhotosCollectionViewDataSource: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchResult.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let asset = fetchResult.object(at: indexPath.item)
        
        // Dequeue a GridViewCell.
        let cellId = String(describing: PhotoGridViewCell.self)
        Utils.registerCCell(collectionView, nibName: cellId, cellId: cellId)
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? PhotoGridViewCell
            else { fatalError("unexpected cell in collection view") }
        
        // Request an image for the asset from the PHCachingImageManager.
        cell.representedAssetIdentifier = asset.localIdentifier
        
        
        imageManager.requestImage(for: asset, targetSize: thumbnailSize, contentMode: .aspectFill, options: nil, resultHandler: { image, _ in
            // The cell may have been recycled by the time this handler gets called;
            // set the cell's thumbnail image only if it's still showing the same asset.
            if cell.representedAssetIdentifier == asset.localIdentifier {
                cell.thumbnailImage = image
            }
        })
        
        return cell
    }

}
