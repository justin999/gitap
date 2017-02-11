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

class ImgurManager {
    static let shared = ImgurManager()
    
    let clientID: String = Configs.imgur.clientId
    
    // MARK: - API Calls
    
    public func uploadImage(image: Data, callback: @escaping ((url: String, width: Int, height: Int, type: String)?, Error?) -> Void) {
        
        Alamofire.request(ImgurRouter.upload(image)).responseJSON { response in
            guard response.result.error == nil else {
                callback(nil, response.result.error)
                return
            }
            
            guard let json = response.result.value as? [String: Any?], let data = json["data"] as? [String: Any?] else {
                callback(nil, ImgurManagerError.objectSerialization(reason: "no data fetched"))
                return
            }
            
            if let url     = data["link"] as? String,
                let width  = data["width"] as? Int,
                let height = data["height"] as? Int,
                let type   = data["type"] as? String {
                callback((url, width, height, type), nil)
            } else {
                callback(nil, ImgurManagerError.objectSerialization(reason: "some element was nil"))
                return
            }
        }
    }

}
