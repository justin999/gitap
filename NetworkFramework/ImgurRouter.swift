//
//  ImgurRouter.swift
//  gitap
//
//  Created by Koichi Sato on 2017/02/07.
//  Copyright © 2017 Koichi Sato. All rights reserved.
//

import Foundation
import Alamofire

enum ImgurRouter: URLRequestConvertible {
    case upload(Data)
    
    func asURLRequest() throws -> URLRequest {
        var method: HTTPMethod {
            switch self {
            case .upload:
                return .post
            }
        }
        
        let url: URL = {
            let relativePath: String
            switch self {
            case .upload(_):
                relativePath = "/image"
            }
            
            var url = URL(string: imgurBaseURLString)!
            url.appendPathComponent(relativePath)
            return url
        }()
        
        let params: ([String: Any]?) = {
            switch self {
            case .upload(let data):
                return ["image": data.base64EncodedString()]
            }
        }()
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        let token = Configs.imgur.clientId
        urlRequest.setValue("Client-ID \(token)", forHTTPHeaderField: "Authorization")
        
        let encoding = JSONEncoding.default
        return try encoding.encode(urlRequest, with: params)
    }
}
