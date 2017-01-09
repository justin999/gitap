//
//  RepoRouter.swift
//  gitap
//
//  Created by Koichi Sato on 1/4/17.
//  Copyright © 2017 Koichi Sato. All rights reserved.
//
//  documentation: https://developer.github.com/v3/repos/

import Foundation
import Alamofire

enum RepoRouter: URLRequestConvertible {
    case listRepos()
    
    func asURLRequest() throws -> URLRequest {
        var method: HTTPMethod {
            switch self {
            case .listRepos:
                return .get
            }
        }
        
        let url: URL = {
            let relativePath: String
            switch self {
            case .listRepos():
                relativePath = "/user/repos"
            }
            
            var url = URL(string: githubBaseURLString)!
            url.appendPathComponent(relativePath)
            return url
        }()
        
        let params: ([String: Any]?) = {
            switch self {
            case .listRepos:
                return nil
            }
        }()
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        // Set Oauth token if we have one
        if let token = GitHubAPIManager.sharedInstance.OAuthToken {
            urlRequest.setValue("token \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let encoding = JSONEncoding.default
        return try encoding.encode(urlRequest, with: params)
    }
}
