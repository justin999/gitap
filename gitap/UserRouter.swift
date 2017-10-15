//
//  UserRouter.swift
//  gitap
//
//  Created by Koichi Sato on 1/7/17.
//  Copyright © 2017 Koichi Sato. All rights reserved.
//

import Foundation
import Alamofire

enum userRouter: URLRequestConvertible {
    case fetchAuthenticatedUser()
    
    func asURLRequest() throws -> URLRequest {
        var method: HTTPMethod {
            switch self {
            case .fetchAuthenticatedUser:
                return .get
            }
        }
        
        let url: URL = {
            let relativePath: String
            switch self {
            case .fetchAuthenticatedUser():
                relativePath = "/user"
            }
            
            var url = URL(string: githubBaseURLString)!
            url.appendPathComponent(relativePath)
            return url
        }()
        
        let params: ([String: Any]?) = {
            switch self {
            case .fetchAuthenticatedUser:
                return nil
            }
        }()
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        // Set Oauth token if we have one
        if let token = GitHubAPIManager.shared.OAuthToken {
            urlRequest.setValue("token \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let encoding = JSONEncoding.default
        return try encoding.encode(urlRequest, with: params)
    }
}

