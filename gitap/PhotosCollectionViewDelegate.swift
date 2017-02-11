//
//  PhotosCollectionViewDelegate.swift
//  gitap
//
//  Created by Koichi Sato on 2017/02/05.
//  Copyright © 2017 Koichi Sato. All rights reserved.
//

import UIKit

class PhotosCollectionViewDelegate: NSObject {
    
    let stateController: StateController
    
    init(collectionView: UICollectionView, stateController: StateController) {
        self.stateController = stateController
        super.init()
        collectionView.delegate = self
    }

}

extension PhotosCollectionViewDelegate: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        let okView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        okView.backgroundColor = UIColor.orange
        cell?.addSubview(okView)
    }
}
