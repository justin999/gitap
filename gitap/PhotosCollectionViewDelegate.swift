//
//  PhotosCollectionViewDelegate.swift
//  gitap
//
//  Created by Koichi Sato on 2017/02/05.
//  Copyright © 2017 Koichi Sato. All rights reserved.
//

import UIKit

protocol PhotosCollectionViewUploadDelegate {
    func uploadActionSelected(_ collectionView: UICollectionView, didSelected indexPath: IndexPath)
}

class PhotosCollectionViewDelegate: NSObject {
    
    let stateController: StateController
    
    var photosCollectionViewUploadDelegate: PhotosCollectionViewUploadDelegate?
    
    init(collectionView: UICollectionView, stateController: StateController) {
        self.stateController = stateController
        super.init()
        collectionView.delegate = self
    }

}

extension PhotosCollectionViewDelegate: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // ここでPhotoGridViewCellにしておかないと複数選択に対応できない
        // もしくは一枚だけしかアップロード対応しないようにする？ -> 確かに複数枚アップできたほうがいいが、今はAPIの制限があるから一枚ずつアップに限定しよう
        // するとgridviewcellをタップ -> 大きく表示 -> アップロードするか聞く -> アップロード押したらアップロード

        // まあこれでimage出せるけどなんか微妙
        // https://stackoverflow.com/a/45983215/5341236
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            print("canceled")
        }
        let uploadAction = UIAlertAction(title: "Upload", style: .default) { [weak self] (action) in
            print("upload action")
            self?.photosCollectionViewUploadDelegate?.uploadActionSelected(collectionView, didSelected: indexPath)
        }
        stateController.presentAlert(title: "Upload this Image?", message: "", style: UIAlertControllerStyle.alert, actions: [cancelAction, uploadAction], completion: nil)
    }
    
    // minimum margin to left or right cells
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return photoThumbnailSize
    }
    
    // minimu margin to above or below cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minimumSpacingBetweenCells
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumSpacingBetweenCells
    }
}
