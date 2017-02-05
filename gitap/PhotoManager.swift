//
//  Photo.swift
//  gitap
//
//  Created by Koichi Sato on 2017/02/05.
//  Copyright © 2017 Koichi Sato. All rights reserved.
//

import UIKit
import Photos

struct PhotoManager {
    
    static let shared = PhotoManager()
    
    var allPhotos: PHFetchResult<PHAsset>!
    var smartAlbums: PHFetchResult<PHAssetCollection>!
    var userCollections: PHFetchResult<PHCollection>!
    
    let sectionLocalizedTitles = ["", NSLocalizedString("Smart Albums", comment: ""), NSLocalizedString("Albums", comment: "")]
    
    init() {
        if allPhotos == nil {
            // Create a PHFetchResult object for each section in the table view.
            let allPhotosOptions = PHFetchOptions()
            allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
            allPhotos = PHAsset.fetchAssets(with: allPhotosOptions)
            smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
            userCollections = PHCollectionList.fetchTopLevelUserCollections(with: nil)
        }
    }
}
