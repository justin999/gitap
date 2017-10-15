//
//  ImgurManager.swift
//  gitap
//
//  Created by Koichi Sato on 2017/02/06.
//  Copyright © 2017 Koichi Sato. All rights reserved.
//

import Foundation
import Alamofire
import Locksmith

let imgurBaseURLString = "https://api.imgur.com/3"

enum ImgurManagerError: Error {
    case network(error: Error)
    case apiProvidedError(reason: String)
    case authCouldNot(reason: String)
    case authLost(reason: String)
    case objectSerialization(reason: String)
}

public protocol ImgurManagerDelegate {
    func imgur(imgur: ImgurManager, didSuceededToUploadWith data: [String: Any?])
    func imgur(imgur: ImgurManager, didFailedToUploadWith error: Error?)
}

open class ImgurManager {
    open static let shared = ImgurManager()
    open var delegate: ImgurManagerDelegate?
    
    let clientID: String = Configs.imgur.clientId
    
    // MARK: - API Calls
    
    open func uploadImage(image: Data) {
        
        Alamofire.request(ImgurRouter.upload(image)).responseJSON { response in
            guard response.result.error == nil else {
                self.delegate?.imgur(imgur: self, didFailedToUploadWith: response.result.error)
                return
            }
            
            guard let json = response.result.value as? [String: Any?], let data = json["data"] as? [String: Any?] else {
                self.delegate?.imgur(imgur: self, didFailedToUploadWith: ImgurManagerError.objectSerialization(reason: "no data fetched"))
                return
            }
            
            if let url     = data["link"] as? String,
                let width  = data["width"] as? Int,
                let height = data["height"] as? Int,
                let type   = data["type"] as? String,
                let datetime = data["datetime"] as? Int {
                let uploadedData: [String: Any?] = [
                    "url": url,
                    "width": width,
                    "height": height,
                    "type": type,
                    "datetime": datetime
                ]
                self.delegate?.imgur(imgur: self, didSuceededToUploadWith: uploadedData)
            } else {
                self.delegate?.imgur(imgur: self, didFailedToUploadWith: ImgurManagerError.objectSerialization(reason: "some element was nil"))
                return
            }
        }
    }

}
