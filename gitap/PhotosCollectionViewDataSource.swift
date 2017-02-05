//
//  PhotosCollectionViewDataSource.swift
//  gitap
//
//  Created by Koichi Sato on 2017/02/05.
//  Copyright © 2017 Koichi Sato. All rights reserved.
//

import UIKit

class PhotosCollectionViewDataSource: NSObject {
    
    var stateController: StateController
    
    init(collectionView: UICollectionView, stateController: StateController) {
        self.stateController = stateController
        super.init()
        collectionView.dataSource = self
    }
    
}

extension PhotosCollectionViewDataSource: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }

}
