//
//  IssueRouter.swift
//  gitap
//
//  Created by Koichi Sato on 1/4/17.
//  Copyright © 2017 Koichi Sato. All rights reserved.
//
//  https://developer.github.com/v3/issues/

import Foundation
import Alamofire

enum IssueRouter: URLRequestConvertible {
    case listIssues([String: Any])
    
    func asURLRequest() throws -> URLRequest {
        var method: HTTPMethod {
            switch self {
            case .listIssues:
                return .get
            }
        }
        
        let url: URL = {
            let relativePath: String
            switch self {
            case .listIssues:
                relativePath = "/issues"
            }
            
            var url = URL(string: githubBaseURLString)!
            url.appendPathComponent(relativePath)
            return url
        }()
        
        let params: ([String: Any]?) = {
            switch self {
            case .listIssues(let parameters):
                return parameters
            }
        }()
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        // Set Oauth token if we have one
        if let token = GitHubAPIManager.sharedInstance.OAuthToken {
            urlRequest.setValue("token \(token)", forHTTPHeaderField: "Authorization")
        }
        
        return try URLEncoding.queryString.encode(urlRequest, with: params)
    }
}

