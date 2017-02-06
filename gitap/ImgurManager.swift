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
    
    public func uploadImage(image: Data, callback: ((url: String, width: Int, height: Int, type: String)?, NSError?) -> Void) {
        
        Alamofire.request(ImgurRouter.upload(image)).responseJSON { response in
                if let urlresponse = response.response {
                    
                }
                
                
//                if response.result.isSuccess {
//                    if let value = response.result.value {
//                        let json = JSON(value)
//                        if let data = json["data"].dictionary {
//                            
//                            var result = (url: "", width: 0, height: 0, type: "")
//                            
//                            if let url = data["link"]?.string {
//                                result.url = url
//                            }
//                            
//                            if let width = data["width"]?.int {
//                                result.width = width
//                            }
//                            
//                            if let height = data["height"]?.int {
//                                result.height = height
//                            }
//                            
//                            if let type = data["type"]?.string {
//                                result.type = type
//                            }
//                            
//                            callback(result, response.result.error)
//                        }
//                    }
//                } else {
//                    callback(nil, response.result.error)
//                }
        }
        
    }
    
}
