//
//  PhotosTableViewDataSource.swift
//  gitap
//
//  Created by Koichi Sato on 2017/02/04.
//  Copyright © 2017 Koichi Sato. All rights reserved.
//

import UIKit
import Photos

// MARK: Types for managing sectionsa and cell
enum Section: Int {
    case allPhotos = 0
    case smartAlbums
    case userCollections
    
    static let count = 3
}

enum CellIdentifier: String {
    case allPhotos, collection
}



class PhotosTableViewDataSource: NSObject {

    var stateController: StateController

    var allPhotos: PHFetchResult<PHAsset>!
    var smartAlbums: PHFetchResult<PHAssetCollection>!
    var userCollections: PHFetchResult<PHCollection>!

    let sectionLocalizedTitles = ["", NSLocalizedString("Smart Albums", comment: ""), NSLocalizedString("Albums", comment: "")]

    
    init(tableView: UITableView, stateController: StateController) {
        self.stateController = stateController
        super.init()
        tableView.dataSource = self

        
        
        // Create a PHFetchResult object for each section in the table view.
        let allPhotosOptions = PHFetchOptions()
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        allPhotos = PHAsset.fetchAssets(with: allPhotosOptions)
        smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
        userCollections = PHCollectionList.fetchTopLevelUserCollections(with: nil)

    }
    
    private func loadPhotos() {
        
    }
}

extension PhotosTableViewDataSource: UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return Section.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionLocalizedTitles[section]
    }


    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section)! {
        case .allPhotos: return 1
        case .smartAlbums: return smartAlbums.count
        case .userCollections: return userCollections.count
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = UITableViewCell()
        
        switch Section(rawValue: indexPath.section)! {
        case .allPhotos:
//            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.allPhotos.rawValue, for: indexPath)
            cell.textLabel!.text = NSLocalizedString("All Photos", comment: "")
            return cell
            
        case .smartAlbums:
//            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.collection.rawValue, for: indexPath)
            let collection = smartAlbums.object(at: indexPath.row)
            cell.textLabel!.text = collection.localizedTitle
            return cell
            
        case .userCollections:
//            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.collection.rawValue, for: indexPath)
            let collection = userCollections.object(at: indexPath.row)
            cell.textLabel!.text = collection.localizedTitle
            return cell
        }
    }

}
